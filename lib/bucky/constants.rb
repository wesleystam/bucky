module Buckaroo
  module Constants

    PAYMENT_STATUS_CODES = {
      "190" => "Payment success",
      "490" => "Payment failure",
      "491" => "Validation error",
      "492" => "Technical error",
      "690" => "Payment rejected",
      "790" => "Waiting for user input",
      "791" => "Waiting for processor",
      "792" => "Waiting on consumer action (e.g.: initiate money transfer)",
      "793" => "Payment on hold (e.g. waiting for sufficient balance)",
      "890" => "Cancelled by consumer",
      "891" => "Cancelled by merchant"
    }
  end
end
