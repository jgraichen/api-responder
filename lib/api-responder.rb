require 'active_support/core_ext'

module ApiResponder
  autoload :VERSION, 'api-responder/version'
  autoload :Formattable, 'api-responder/formattable'
end

module Responders
  autoload :ApiResponder, 'responders/api_responder'
end
