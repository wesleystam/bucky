require 'addressable/uri'

module Buckaroo
  class Response

    def initialize(raw_response)
      @raw_response = raw_response
    end

    def redirect_url
      converted_response["BRQ_REDIRECTURL"]
    end

    def status
      converted_response["BRQ_STATUSCODE"].to_i
    end

    def human_readable_status
      Buckaroo::Constants::PAYMENT_STATUS_CODES[status.to_s]
    end

    private

    def converted_response
      @converted_response  ||= Hash[unescape_raw_response]
    end

    # Using Addressable converts the raw_response into something like:
    # [
    #   ["BRQ_WEBSITEKEY", "very-secure"],
    #   ["BRQ_SIGNATURE", "b871a4bc3b30c34df70949d3e20903dcd0810fd9"]
    # ]
    # Which is much easier to work with
    def unescape_raw_response
      Addressable::URI.form_unencode(@raw_response)
    end
  end
end
