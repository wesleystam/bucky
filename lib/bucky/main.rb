module Buckaroo
  class Main

    def initialize(brq_options = {})
      @brq_options = brq_options
    end

    def post_payment
      params_with_signature = transaction_parameters.merge(brq_signature: signature)

      HTTParty.post(Buckaroo::Config.endpoint, body: params_with_signature)
    end

    def transaction_parameters
      {
        brq_websitekey:     Buckaroo::Config.websitekey,
        brq_culture:        Buckaroo::Config.culture
      }.merge(@brq_options)
    end

    def self.successful_payment?(params)
      code = params[:BRQ_STATUSCODE] || params[:brq_statuscode]
      Constants::PAYMENT_STATUS_CODES[code] == 'Payment success'
    end

    def endpoint
      Buckaroo::Config.endpoint
    end

    private

    def signature
      Buckaroo::Signature.new(client_options_with_defaults).to_s
    end

  end
end
