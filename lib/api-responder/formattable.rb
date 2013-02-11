module ApiResponder
  module Formattable
    class UnsupportedVersion < StandardError; end

    module ClassMethods
      def api_formats(*formats)
        @api_formats ||= [ :json ]
        return @api_formats if formats.empty?

        formats.map!(&:to_sym)
        formats -= @api_formats

        formats.each do |format|
          method = :"to_#{format}"
          send :define_method, method do |options|
            as_api(options.merge(:format => format)).send method, options
          end
          @api_formats << format
        end
      end
    end

    module InstanceMethods
      def as_json(options)
        as_api(options.merge(:format => :json)).as_json(options)
      end

      def as_api(options)
        method = :"as_api_v#{options[:api_version] || 1}"
        raise UnsupportedVersion.new unless respond_to? method

        options.delete(:api_version)
        return send method, options
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
