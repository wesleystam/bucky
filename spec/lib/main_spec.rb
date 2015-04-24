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
    it "merges the given keys with the keys provided in the config" do
      main = Buckaroo::Main.new({brq_amount: 10.0})
      expect(main.params_with_signature.keys)
        .to eq([:brq_websitekey, :brq_culture, :brq_amount, :brq_signature])
    end
  end

end
