require "spec_helper"

describe Buckaroo::Constants do
  it "returns a list of status codes" do
    expected_status_codes = %w(190 490 491 492 690 790 791 792 793 890 891)
    expect(Buckaroo::Constants::PAYMENT_STATUS_CODES.keys).to eq(expected_status_codes)
  end
end
