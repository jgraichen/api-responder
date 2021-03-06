# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api-responder/version'

Gem::Specification.new do |gem|
  gem.name          = "api-responder"
  gem.version       = ApiResponder::VERSION
  gem.authors       = ["Jan Graichen"]
  gem.email         = ["jg@altimos.de"]
  gem.description   = %q{ApiResponder simplifies version dependent rendering of API resources.}
  gem.summary       = %q{ApiResponder simplifies version dependent rendering of API resources.}
  gem.homepage      = ""
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport'
end
