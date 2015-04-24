module Buckaroo
  class PaymentResponse

    def initialize(params = {})
      @params = params
    end

    def successful_payment?
      Constants::PAYMENT_STATUS_CODES[status_code] == 'Payment success'
    end

    private

    attr_reader :params

    def status_code
      params["BRQ_STATUSCODE"] || params["brq_statuscode"]
    end

  end
end
