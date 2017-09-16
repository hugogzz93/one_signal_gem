
module Restforce
  class << self
    attr_writer :log

    # Returns the current Configuration
    #
    # Example
    #
    #    OneSignal.configuration.app_id = "app_id"
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the Configuration
    #
    # Example
    #
    #    OneSignal.configure do |config|
    #      config.aoo_id = "app_id"
    #    end
    def configure
      yield configuration
    end
  end

  class Configuration
    class Option
      attr_reader :configuration, :name, :options

      def self.define(*args)
        new(*args).define
      end

      def initialize(configuration, name, options = {})
        @configuration = configuration
        @name = name
        @options = options
        @default = options.fetch(:default, nil)
      end

      def define
        write_attribute
        define_method if default_provided?
        self
      end

      private

      attr_reader :default
      alias_method :default_provided?, :default

      def write_attribute
        configuration.send :attr_accessor, name
      end

      def define_method
        our_default = default
        our_name    = name
        configuration.send :define_method, our_name do
          instance_variable_get(:"@#{our_name}") ||
            instance_variable_set(
              :"@#{our_name}",
              our_default.respond_to?(:call) ? our_default.call : our_default
            )
        end
      end
    end

    class << self
      attr_accessor :options

      def option(*args)
        option = Option.define(self, *args)
        (self.options ||= []) << option.name
      end
    end

    def options
      self.class.options
    end
  end
end
