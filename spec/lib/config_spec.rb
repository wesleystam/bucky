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

  it "has a secret" do
    Buckaroo::Config.configure(secret: "this-is-very-secret")
    expect(Buckaroo::Config.secret)
      .to eq("this-is-very-secret")
  end

  it "has a default secret url" do
    Buckaroo::Config.configure
    expect(Buckaroo::Config.secret)
      .to eq("")
  end

  it "has a default websitekey" do
    Buckaroo::Config.configure
    expect(Buckaroo::Config.websitekey)
      .to eq("")
  end

  it "has a websitekey" do
    Buckaroo::Config.configure(websitekey: "very-secure")
    expect(Buckaroo::Config.websitekey)
      .to eq("very-secure")
  end

  it "has a culture" do
    Buckaroo::Config.configure(culture: "en-GB")
    expect(Buckaroo::Config.culture)
      .to eq("en-GB")
  end

  it "has a default culture" do
    Buckaroo::Config.configure
    expect(Buckaroo::Config.culture)
      .to eq("nl-NL")
  end

end
