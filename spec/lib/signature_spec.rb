require "spec_helper"

describe Buckaroo::Signature do
  describe "#valid" do
    it "is valid when the calculated signature matches the provided signature" do
      Buckaroo::Config.configure(secret: "very-secret")
      calculated_signature = Buckaroo::Signature.valid?(transaction_success_response)
      expect(calculated_signature).to eq(true)
    end

    it "returns false when the calculated signature does not match the one provided" do
      Buckaroo::Config.configure(secret: "not-so-secret")
      calculated_signature = Buckaroo::Signature.valid?(transaction_success_response)
      expect(calculated_signature).to eq(false)
    end
  end

  describe "#to_s" do
    it "returns a calculated signature" do
      Buckaroo::Config.configure(secret: "very-secret")
      signature = Buckaroo::Signature.new(transaction_success_response).to_s
      expect(signature).to eq("2b24d8f839978a15e031655b6698736be7e6c540")
    end

    it "returns a different signature if the secret key changes" do
      Buckaroo::Config.configure(secret: "very-very-secret")
      signature = Buckaroo::Signature.new(transaction_success_response).to_s
      expect(signature).to_not eq("2b24d8f839978a15e031655b6698736be7e6c540")
    end
  end

  def transaction_success_response
    {
      "BRQ_AMOUNT"=>"22.00",
      "BRQ_CURRENCY"=>"EUR",
      "BRQ_CUSTOMER_NAME"=>"J. de Tèster",
      "BRQ_DESCRIPTION"=>"order 9",
      "BRQ_INVOICENUMBER"=>"9",
      "BRQ_PAYER_HASH"=>"102c7f25042d0377eba70b2c4ea49547c84316a9fac2c61ff1a3c3ba09375057ca98e2dd777635007b4b9b992db85309ae0379ddb87892137fe70977d598d4b8",
      "BRQ_PAYMENT"=>"C8566C065C9247D9AF8377569242C191",
      "BRQ_PAYMENT_METHOD"=>"ideal",
      "BRQ_SERVICE_IDEAL_CONSUMERBIC"=>"RABONL2U",
      "BRQ_SERVICE_IDEAL_CONSUMERIBAN"=>"NL44RABO0123456789",
      "BRQ_SERVICE_IDEAL_CONSUMERISSUER"=>"Rabobank",
      "BRQ_SERVICE_IDEAL_CONSUMERNAME"=>"J. de Tèster",
      "BRQ_STATUSCODE"=>"190",
      "BRQ_STATUSCODE_DETAIL"=>"S001",
      "BRQ_STATUSMESSAGE"=>"Transaction successfully processed",
      "BRQ_TEST"=>"true",
      "BRQ_TIMESTAMP"=>"2015-04-22 10:43:35",
      "BRQ_TRANSACTIONS"=>"712C8062B24247CEA878F632942E6511",
      "BRQ_WEBSITEKEY"=>"very-secure",
      "BRQ_SIGNATURE"=>"f8e3eba8d6e98ce770e48014e33b4545636b8fa9"
    }
  end

end
