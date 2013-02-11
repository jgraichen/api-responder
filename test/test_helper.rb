require 'minitest/autorun'
require 'bundler'

Bundler.setup

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'mocha'
require 'minitest/ansi'
MiniTest::ANSI.use!

require 'active_support'
require 'action_controller'


Responders::Routes = ActionDispatch::Routing::RouteSet.new
Responders::Routes.draw do
  match '/' => 'app#index'
  match '/api/v1/index' => 'app#v1'
  match '/api/v2/index' => 'app#v2'
  match '/index' => 'custom#index'
end

class ActiveSupport::TestCase
  setup do @routes = Responders::Routes end
end

class AppResponder < ActionController::Responder
  include Responders::ApiResponder
end

class AppController < ActionController::Base
  include Responders::Routes.url_helpers
  self.responder = AppResponder
  respond_to :json
  def index; respond_with params[:resource]; end
  def v1; respond_with params[:resource]; end
  def v2; respond_with params[:resource]; end
end

class CustomController < ActionController::Base
  include Responders::Routes.url_helpers
  self.responder = AppResponder
  respond_to :json
  def index; respond_with params[:resource]; end
  def api_version; return $1 if request.headers["Accept"] =~ /vnd\.test.v(\d+)/; end
end

class Resource
  include ApiResponder::Formattable

  def as_api_v1(opts); { :av => 1 }; end
  def as_api_v2(opts); { :av => 2 }; end
end
