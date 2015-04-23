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

    def body_to_string
      sanitized_body.keys.sort_by(&:downcase).map{|key| "#{key}=#{@body[key]}" }.join("")
    end

    def sanitized_body
      @body.map{|key, value| @body[key] = value.to_s.gsub("+",' ')}
      @body
    end
  end
end
