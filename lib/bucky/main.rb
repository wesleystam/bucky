module Buckaroo
  class Main

    def initialize(params = {})
      @params = params
    end

    def post_payment
      HTTParty.post(Buckaroo::Config.endpoint,
                    body: params_with_signature)
    end

    def params_with_signature
      transaction_parameters.merge(brq_signature: signature)
    end

    def self.successful_payment?(params)
      code = params[:BRQ_STATUSCODE] || params[:brq_statuscode]
      Constants::PAYMENT_STATUS_CODES[code] == 'Payment success'
    end

    private

    def transaction_parameters
      {
        brq_websitekey:     Buckaroo::Config.websitekey,
        brq_culture:        Buckaroo::Config.culture
      }.merge(@params)
    end


    def endpoint
      Buckaroo::Config.endpoint
    end

    def signature
      Buckaroo::Signature.new(transaction_parameters).to_s
    end

  end
end
