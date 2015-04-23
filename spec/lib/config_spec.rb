require "spec_helper"

describe Buckaroo::Config do

  it "has an endpoint url" do
    Buckaroo::Config.configure(endpoint: "https://testcheckout.buckaroo.nl/nvp/")
    expect(Buckaroo::Config.endpoint)
      .to eq("https://testcheckout.buckaroo.nl/nvp/")
  end

  it "has a default endpoint url" do
    Buckaroo::Config.configure
    expect(Buckaroo::Config.endpoint)
      .to eq("https://checkout.buckaroo.nl/nvp/")
  end

end
