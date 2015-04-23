module Buckaroo
  class Config
    class << self

      # The endpoint to which your app will connect.
      # expects a string which is a valid url
      attr_accessor :endpoint

      #The secret provided by Buckaroo
      attr_accessor :secret

      # the website key you generated on the configuration panel
      # in Buckaroo
      attr_accessor :websitekey

      def defaults
        {
          endpoint: "https://checkout.buckaroo.nl/nvp/",
          secret: "",
          websitekey: ""
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
