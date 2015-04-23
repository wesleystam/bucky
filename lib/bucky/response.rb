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

    def human_status
      Buckaroo::Constants::PAYMENT_STATUS_CODES[status.to_s]
    end

    private

    def converted_response
      @converted_response  ||= Hash[Addressable::URI.form_unencode(@raw_response)]
    end
  end
end
