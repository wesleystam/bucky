require 'httparty'

module Buckaroo
  class Main

    def initialize(params = {})
      @params = params
    end

    def post_transaction_request
      HTTParty.post(Buckaroo::Config.endpoint, body: params_with_signature)
    end

    def params_with_signature
      transaction_parameters.merge(brq_signature: signature)
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
