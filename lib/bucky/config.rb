module Buckaroo
  class Config
    class << self

      # The endpoint to which your app will connect.
      # expects a string which is a valid url
      attr_accessor :endpoint

      def defaults
        {
          endpoint: "https://checkout.buckaroo.nl/nvp/"
        }
      end

      def configure(settings = {})
        defaults.merge(settings).each do |key, value|
          instance_variable_set(:"@#{key}", value)
        end
      end

    end
  end
end
