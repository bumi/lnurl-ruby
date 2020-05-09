# LNURL tools for Ruby

LNURL is a protocol for interaction between Lightning wallets and third-party services.

This gem provides helpers to work with LNURLs from Ruby.


## Links:

* [LNURL: Lightning Network UX protocol RFC](https://github.com/btcontract/lnurl-rfc)
* [Awesome LNURL - a curated list with things related to LNURL](https://github.com/fiatjaf/awesome-lnurl)
* [LNURL pay flow](https://xn--57h.bigsun.xyz/lnurl-pay-flow.txt)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lnurl'
```

Or install it yourself as:

    $ gem install lnurl

## Usage

### Encoding

```ruby
lnurl = Lnurl.new('https://lnurl.com/pay')
puts lnurl.to_bech32 # => LNURL1DP68GURN8GHJ7MRWW4EXCTNRDAKJ7URP0YVM59LW
```

### Decoding

```ruby
Lnurl.valid?('nolnurl') #=> false

lnurl = Lnurl.decode('LNURL1DP68GURN8GHJ7MRWW4EXCTNRDAKJ7URP0YVM59LW')
lnurl.uri # => #<URI::HTTPS https://lnurl.com/pay>
```

### LNURL responses

```ruby
lnurl = Lnurl.decode('LNURL1DP68GURN8GHJ7MRWW4EXCTNRDAKJ7URP0YVM59LW')
response = lnurl.response # => #<Lnurl::LnurlResponse status="OK" ...
response.status # => OK / ERROR
response.callback # => https://...
response.tag # => payRequest
response.maxSendable # => 100000000
response.minSendable # => 1000
response.metadata # => [...]

invoice = response.request_invoice(amount: 1000) # (amount in satoshi) #<Lnurl::InvoiceResponse status="OK"
invoice.status # => OK / ERROR
invoice.pr # => lntb20u1p0tdr7mpp...
invoice.successAction # => {...}
invoice.routes # => [...]

```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bumi/lnurl-ruby.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
