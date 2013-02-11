# Responders::ApiResponder

`ApiResponder` simplifies version dependent rendering of API resources using a custom responder and a mixin for decorators or models (decorators are recommended).

## Installation

Add this line to your application's Gemfile:

    gem 'api-responder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api-responder

## Usage

Add `Responders::ApiResponder` to your responder chain:

```ruby
class AppResponder < Responder
  include Responders::ApiResponder
end

class MyController < ApplicationController
  self.responder = ApiResponder
end
```

Or use it with [plataformatec/responders](https://github.com/plataformatec/responders):

```ruby
class MyController < ApplicationController
  responders Responders::ApiResponder
end
```

This will add an API version parameter to the options hash for formatting methods like `as_json`. You can override the formatting methods or just include `ApiResponder::Formattable`:

```ruby
class MyModel
  include ApiResponder::Formattable

  api_formats :xml

  def as_api_v1
    {
      id: id,
      first_name: name.split.first
      last_name: name.split.last
    }
  end

  def as_api_v2
    as_api_v1.merge name: "#{first_name} #{last_name}"
  end
end
```

This will add a handler for XML. You can specify any format your want. `ApiResponder::Formattable` will override the `to_{format}` (e.g. `to_xml`) method to call `to_{format}` on the API specific hash. JSON is supported via `as_json` by default.

The only included method to detect API version is matching the URL path `/api/v(\d+)`. Or you can add an `api_version` method to your controller:

```ruby
class MyController < ApplicationController
  responders Responders::ApiResponder

  def api_version
    return $1 if request.headers["Accept"] =~ /vnd\.myapp.v(\d+)/
  end
end
```

I recommend using `ApiResponder` in combination with [jgraichen/decorate-responder](https://github.com/jgraichen/decorate-responder) and the decorator pattern (like [draper](https://github.com/drapergem/draper)):

```ruby
class User < ActiveRecord::Base
  attr_accessible :id, :first_name, :last_name
end

class UserDecorator < Draper::Decorator
  include ApiResponder::Formattable
  decorates :user

  api_formats :msgpack

  def name
    "#{first_name} #{last_name}"
  end

  def as_api_v1
    {
      id: model.id,
      created_at: model.created_at.utc.iso8601,
      name: name
    }
  end
end

class UsersController < ApplicationController
  responders Responders::ApiResponder,
    Responders::DecorateResponder

  respond_to :json, :xml, :msgpack
  rescue_from ApiResponder::Formattable::UnsupportedVersion do
    head :not_acceptable
  end

  def index
    respond_with User.scoped
  end

  def api_version
    return $1 if request.headers["Accept"] =~ /vnd\.myapp.v(\d+)/
  end
end
```

When `ApiResponder::Formattable` receives nil as API version or the resource does not have a matching `as_api_v` method an `UnsupportedVersion` error will be raised. You can catch that exception and for example return a `406` status code:

```ruby
rescue_from ApiResponder::Formattable::UnsupportedVersion do
  head :not_acceptable
end
```

Check out [jgraichen/paginate-responder](https://github.com/jgraichen/paginate-responder) for automagic pagination support including HTTP Link headers.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests for your feature
4. Add your feature
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright (c) 2013 Jan Graichen
