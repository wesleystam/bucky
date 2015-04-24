require "spec_helper"

describe Buckaroo::Main do
  before do
    Buckaroo::Config.configure(endpoint: "https://testcheckout.buckaroo.nl/nvp/",
                               secret: "very-secret",
                               websitekey: "very-secure")
  end

  describe "#params_with_signature" do
    it "merges the given keys with the keys provided in the config" do
      main = Buckaroo::Main.new({brq_amount: 10.0})
      expect(main.params_with_signature.keys)
        .to eq([:brq_websitekey, :brq_culture, :brq_amount, :brq_signature])
    end
  end

  describe "#post_transaction_request" do
    it "performs a transactions request " do
      allow(HTTParty).to receive(:post).and_return(raw_response)

      main = Buckaroo::Main.new(transaction_request_parameters)
      raw_result = main.post_transaction_request

      expect(HTTParty).to have_received(:post)
      expect(raw_result).to eq(raw_response)
    end
  end

  def transaction_request_parameters
    {
      brq_amount:         1.0,
      brq_currency:       "EUR",
      brq_invoicenumber:  46,
      brq_description:    "order 46",
      brq_return:         "http://localhost:3000/transactions/46/callback_success",
      brq_returnreject:   "http://localhost:3000/transactions/46/callback_reject",
      brq_returncancel:   "http://localhost:3000/transactions/46/callback_cancel",
      brq_returnerror:    "http://localhost:3000/transactions/46/callback_error",
      brq_continue_on_incomplete: "RedirectToHTML" #Or no to redirect to html
    }
  end

  def raw_response
    "BRQ_ACTIONREQUIRED=redirect&BRQ_AMOUNT=123.00&BRQ_APIRESULT=ActionRequired&BRQ_CURRENCY=EUR&BRQ_DESCRIPTION=order+46&BRQ_INVOICENUMBER=46&BRQ_MUTATIONTYPE=NotSet&BRQ_REDIRECTURL=https%3a%2f%2ftestcheckout.buckaroo.nl%2fhtml%2fredirect.ashx%3fr%3d82CBA1A6EDC245C0B5D48CD38DF0CF32&BRQ_STATUSCODE=790&BRQ_STATUSMESSAGE=Pending+input&BRQ_TEST=true&BRQ_TIMESTAMP=2015-04-24+11%3a31%3a35&BRQ_TRANSACTIONS=E56EC0D0BC614F958486BC87F97D997A&BRQ_WEBSITEKEY=very-secure&BRQ_SIGNATURE=614e5d6df26e5995e25aa8deb9e0ca9c745e009d"
  end

end
