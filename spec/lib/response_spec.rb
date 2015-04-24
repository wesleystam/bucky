require 'spec_helper'

describe Buckaroo::Response do
  let(:successful_response) { Buckaroo::Response.new(raw_response) }
  let(:failed_response) {  Buckaroo::Response.new(failed_raw_response) }

  describe "#redirect_url" do
    it 'has a redirect_url' do
      expect(successful_response.redirect_url)
        .to eq("https://testcheckout.buckaroo.nl/html/redirect.ashx?r=460A4BB2937247EAB4CCE20E8025F13A")
    end

    it "does not have a redirect_url when the request is missing required key currency" do
      expect(failed_response.redirect_url).to eq(nil)
    end
  end

  describe "#status" do
    it "has a status" do
      waiting_for_user_input = 790
      expect(successful_response.status).to eq(waiting_for_user_input)
    end

    it "has a status stating failed when request is missing required key currency" do
      validation_error = 491
      expect(failed_response.status).to eq(validation_error)
    end
  end

  describe "#human_readable_status" do
    it "is waiting for user input when response is successful" do
      expect(successful_response.human_readable_status)
        .to eq("Waiting for user input")
    end

    it "has status validation error when the response has errors" do
      expect(failed_response.human_readable_status)
        .to eq("Validation error")
    end
  end

  def raw_response
    "BRQ_ACTIONREQUIRED=redirect&BRQ_AMOUNT=22.00&BRQ_APIRESULT=ActionRequired&BRQ_CURRENCY=EUR&BRQ_DESCRIPTION=order+17&BRQ_INVOICENUMBER=17&BRQ_MUTATIONTYPE=NotSet&BRQ_REDIRECTURL=https%3a%2f%2ftestcheckout.buckaroo.nl%2fhtml%2fredirect.ashx%3fr%3d460A4BB2937247EAB4CCE20E8025F13A&BRQ_STATUSCODE=790&BRQ_STATUSMESSAGE=Pending+input&BRQ_TEST=true&BRQ_TIMESTAMP=2015-04-22+08%3a32%3a48&BRQ_TRANSACTIONS=0A637657F03F40FB872C9763E1357340&BRQ_WEBSITEKEY=very-secure&BRQ_SIGNATURE=b871a4bc3b30c34df70949d3e20903dcd0810fd9"
  end

  def failed_raw_response
    "BRQ_AMOUNT=123.00&BRQ_APIRESULT=Fail&BRQ_DESCRIPTION=order+45&BRQ_INVOICENUMBER=45&BRQ_MUTATIONTYPE=NotSet&BRQ_STATUSCODE=491&BRQ_STATUSMESSAGE=Validation+failure&BRQ_TEST=true&BRQ_TIMESTAMP=2015-04-24+10%3a10%3a19&BRQ_TRANSACTIONS=384AFAC394CE42B5A0E569D7FB0EC6CE&BRQ_WEBSITEKEY=very-secure&BRQ_SIGNATURE=43530f9b8d9d194befb379d01f53baec83878d63"
  end
end
