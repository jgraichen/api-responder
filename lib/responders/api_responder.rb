module Responders
  module ApiResponder
    def options
      super.merge(api_options)
    end

    def api_options
      { :api_version => api_version }
    end

    def api_version
      return controller.api_version if controller.respond_to? :api_version
      detect_api_version
    end

    def detect_api_version
      return $1.to_i if request.path =~ /^\/api\/v(\d+)\//
      nil
    end
  end
end
