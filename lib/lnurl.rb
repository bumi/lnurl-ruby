require 'bech32'
require 'net/http'
require 'json'
require 'ostruct'

class Lnurl
  VERSION = '1.0.1'.freeze

  InvoiceResponse = Class.new(OpenStruct)
  LnurlResponse = Class.new(OpenStruct) do
    # amount in msats
    def request_invoice(args)
      args.transform_keys!(&:to_s)
      callback_uri = URI(callback)
      if callback_uri.query
        args = Hash[URI.decode_www_form(callback_uri.query)].merge(args) # reverse merge
      end
      callback_uri.query = URI.encode_www_form(args)
      body = Net::HTTP.get(callback_uri)
      InvoiceResponse.new JSON.parse(body)
    end
  end

  HRP = 'lnurl'.freeze
  MAX_INTEGER = 2**31.freeze

  attr_reader :uri

  def initialize(uri)
    @uri = URI(uri)
  end

  def to_bech32
    Bech32.encode(HRP, data, Bech32::Encoding::BECH32).upcase
  end
  alias encode to_bech32

  def data
    self.class.convert_bits(uri.to_s.codepoints, 8, 5, true)
  end

  def response
    @response ||= begin
                    body = Net::HTTP.get(uri) # TODO: redirects?
                    LnurlResponse.new JSON.parse(body)
                  end
  end

  def request_invoice(amount:)
    response.request_invoice(amount: amount)
  end

  def payment_request(amount:)
    request_invoice(amount: amount).pr
  end

  def self.valid?(value)
    return false unless value.to_s.downcase.match?(Regexp.new("^#{HRP}", 'i')) # false if the HRP does not match
    decoded = decode_raw(value) rescue false # rescue any decoding errors
    return false unless decoded # false if it could not get decoded

    return decoded.match?(URI.regexp) # check if the URI is valid
  end

  def self.decode(lnurl)
    Lnurl.new(decode_raw(lnurl))
  end

  def self.decode_raw(lnurl)
    lnurl = lnurl.gsub(/^lightning:/, '')
    hrp, data, sepc = Bech32.decode(lnurl, MAX_INTEGER)
    # raise 'no lnurl' if hrp != HRP
    convert_bits(data, 5, 8, false).pack('C*').force_encoding('utf-8')
  end

  # FROM: https://github.com/azuchi/bech32rb/blob/master/lib/bech32/segwit_addr.rb
  def self.convert_bits(data, from, to, padding=true)
    acc = 0
    bits = 0
    ret = []
    maxv = (1 << to) - 1
    max_acc = (1 << (from + to - 1)) - 1
    data.each do |v|
      return nil if v < 0 || (v >> from) != 0
      acc = ((acc << from) | v) & max_acc
      bits += from
      while bits >= to
        bits -= to
        ret << ((acc >> bits) & maxv)
      end
    end
    if padding
      ret << ((acc << (to - bits)) & maxv) unless bits == 0
    elsif bits >= from || ((acc << (to - bits)) & maxv) != 0
      return nil
    end
    ret
  end
end
