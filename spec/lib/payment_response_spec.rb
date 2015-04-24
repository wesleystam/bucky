require "spec_helper"

describe Buckaroo::PaymentResponse do
  describe "#successful_payment?" do
    it "returns true when the payment has status payment success" do
      successful_payment = Buckaroo::PaymentResponse.successful_payment?(callback_success_response)
      expect(successful_payment).to eq(true)
    end

    it "returns false when the payment has a status other than success" do
      failed_payment = Buckaroo::PaymentResponse.successful_payment?(callback_failure_response)
      expect(failed_payment).to eq(false)
    end

  end

  def callback_success_response
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
      "BRQ_SIGNATURE"=>"90a30e331fe543ed3409dc57e399def07238766c"
    }
  end

  def callback_failure_response
    {
      "BRQ_AMOUNT"=>"22.00",
      "BRQ_CURRENCY"=>"EUR",
      "BRQ_DESCRIPTION"=>"order 9",
      "BRQ_INVOICENUMBER"=>"9",
      "BRQ_PAYMENT"=>"ED3A4B657D014CF49B58AB891B9BE89F",
      "BRQ_PAYMENT_METHOD"=>"ideal",
      "BRQ_SERVICE_IDEAL_CONSUMERISSUER"=>"Rabobank",
      "BRQ_STATUSCODE"=>"690",
      "BRQ_STATUSCODE_DETAIL"=>"S101",
      "BRQ_STATUSMESSAGE"=>"The transaction was rejected during processing by DeutscheBankProcessor. ",
      "BRQ_TEST"=>"true",
      "BRQ_TIMESTAMP"=>"2015-04-22 14:00:41",
      "BRQ_TRANSACTIONS"=>"E71C8BD066B24C449F595369C10F1C4C",
      "BRQ_WEBSITEKEY"=>"very-secure",
      "BRQ_SIGNATURE"=>"2ce7dc0ee422ccda5e2e11b414f038643a228019",
    }
  end
end
