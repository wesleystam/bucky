require 'active_support/hash_with_indifferent_access'

module Buckaroo
  class Signature
    attr_accessor :body

    def initialize(hash)
      @body = hash.dup
    end

    def to_s
      Digest::SHA1.hexdigest(body_to_string.split("\n").join("") + secret_key)
    end

    def self.valid?(params)
      hash = HashWithIndifferentAccess.new(params.select{ |key, value| key.to_s.match(/^brq_|^add_|^cust_/i) })
      signature = hash.delete(:brq_signature) || hash.delete(:BRQ_SIGNATURE)

      self.new(hash).to_s == signature
    end

    private

    def secret_key
      Buckaroo::Config.secret
    end

    # Modifies the given hash according to the Buckaroo API documentation.
    #
    #
    # The calculation is done as follows:
    # 1. Create a list with all the fields in the params given that start with brq_, add_ or cust_ in the following format: brq_fieldname=Value
    #  2. Sort this list on alphabetical order based on the field_name (brq_amount should come before brq_websitekey).
    #  Note: Sort should NOT be  done case-sensitive. Case should be preserved in  the values. Example: BRQ_AMOUNT=1.00brq_currency=EURbrq_websitekey=asdfasdfsecret
    #  3. Join all these values as a string. Do not use any whitespace.
    #  Example: BRQ_AMOUNT=1.00brq_currency=EURbrq_websitekey=asdfasdfsecretkey
    #  4. Append the pre-shared secret key to this string. *(Buckaroo::Config.secret).
    #  5. Calculate the SHA-1 hash of this string in a hexadecimal format and compare it to the signature given in the response.

    def body_to_string
      sanitized_body.keys.sort_by(&:downcase).map{|key| "#{key}=#{@body[key]}" }.join("")
    end

    def sanitized_body
      @body.map{|key, value| @body[key] = value.to_s.gsub("+",' ')}
      @body
    end
  end
end
