require 'minitest/autorun'
require 'bundler'

Bundler.setup

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end
