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

end
