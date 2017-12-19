# URI::AMQP

[Custom URI](https://ruby-doc.org/stdlib-2.4.2/libdoc/uri/rdoc/URI.html#module-URI-label-Adding+custom+URIs) implementation for AMQP  


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uri-amqp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uri-amqp

## Usage

As any other URI (HTTP, FTP, LDAP) you may call `URI.parse` with string argument and it will automatically detect scheme and return `URI::AMQP` or `URI::AMQPS` instance.

```ruby
uri = URI.parse("amqps://user:pass@host/vhost?heartbeat=10&connection_timeout=100&channel_max=1000&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem")
=> #<URI::AMQPS amqps://user:pass@host/vhost?heartbeat=10&connection_timeout=100&channel_max=1000&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem>
uri.scheme
=> "amqp"
uri.user
=> "user"
uri.password
=> "pass"
uri.host
=> "host"
uri.vhost
=> "vhost"
uri.vhost
=> "vhost"
uri.heartbeat
=> 10
uri.connection_timeout
=> 100
uri.channel_max
=> 1000
uri.verify
=> false
uri.fail_if_no_peer_cert
=> false
uri.cacertfile
=> nil
uri.certfile 
=> "/examples/tls/client_cert.pem"
uri.keyfile
=> "/examples/tls/client_key.pem"
```

There are also implemented some checks:

```
uri = URI.parse("amqp://host/vhost/hurricane")
=> URI::InvalidComponentError: bad vhost (expected only leading "/"): /vhost/hurricane

uri = URI.parse("amqp://host/vhost?certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem")
=> URI::InvalidComponentError: bad certfile (expected only in "amqps" schema): /examples/tls/client_cert.pem
``` 

### References

# https://www.rabbitmq.com/uri-spec.html
# https://www.rabbitmq.com/uri-query-parameters.html
# https://www.rabbitmq.com/ssl.html

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Tensho/uri-amqp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the URI::AMQP project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Tensho/uri-amqp/blob/master/CODE_OF_CONDUCT.md).
