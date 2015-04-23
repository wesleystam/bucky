require "spec_helper"

describe Buckaroo::Main do
  before do
    Buckaroo::Config.configure
  end

  it "returns a default endpoint if not set" do
    expect(Buckaroo::Main.new({}).endpoint).to_not be_nil
  end

  it "calculates a default signature without any options" do
    expect(Buckaroo::Main.new({}).send(:signature))
      .to eq("a9bfac3a9c8f0e775a40a9465bcfe74005d415fb")
  end

  describe "#set body" do
    it "merges the body parameters given with the config ones" do
      main = Buckaroo::Main.new({brq_amount: 10.0})
      expect(main.transaction_parameters.keys)
        .to eq([:brq_websitekey, :brq_culture, :brq_amount])
    end
  end

  def transaction_parameters
    {
      brq_amount:         10.0,
      brq_currency:       'EUR',
      brq_invoicenumber:  'invoice-number',
      brq_description:    "description",
      brq_return:         "return-url",
      brq_returnreject:   "return-reject-url",
      brq_returncancel:   "return-cancel-url",
      brq_returnerror:    "return-error-url",
      brq_continue_on_incomplete: "RedirectToHTML" #Or no to redirect to html
    }
  end


end
