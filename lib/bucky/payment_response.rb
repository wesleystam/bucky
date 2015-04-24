module Buckaroo
  class PaymentResponse

    def self.successful_payment?(params)
      code = params["BRQ_STATUSCODE"] || params["brq_statuscode"]
      Constants::PAYMENT_STATUS_CODES[code] == 'Payment success'
    end

  end
end
