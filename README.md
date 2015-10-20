# Ruby-Dovado

A Dovado Router API for Ruby.

[![Build Status](https://drone.io/bitbucket.org/janlindblom/ruby-dovado/status.png)](https://drone.io/bitbucket.org/janlindblom/ruby-dovado/latest)
[![Gem](https://img.shields.io/gem/v/ruby-dovado.svg?style=flat-square)](https://rubygems.org/gems/ruby-dovado)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg?style=flat-square)](http://www.rubydoc.info/gems/ruby-dovado/frames)
[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square)](#copyright)

This library serves to enable easy access to the built in, Telnet-based, rudimentary API of the [routers from Dovado](http://www.dovado.com/en/products) running software version 6 and 7 (applies to the original Tiny and Go routers, among others). It might work with software version 8 routers (the Tiny AC) too but I have no means to test against that since I don't have one of the later routers.

## Purpose

The original purpose of this library was to enable addition of router information about connection state, mobile data connection quality and data quota usage on a wall-mounted TV or a small touch screen connected to a Raspberry Pi, accessing a dashboard implemented using [Dashing](https://shopify.github.io/dashing/).

## Usage

Add it to your Gemfile:

```ruby
gem "ruby-dovado"
```

They load it in your code:

```ruby
require "dovado"

router = Dovado::Router.new(address: "192.168.0.1", user: "admin", password: "password")
router.info
router.sms.load_messages
message = router.sms.get_message 12
```

## Design Considerations

Since the API published by these routers is Telnet-based, it stands to reason to limit simultaneous connections. This is achieved by a single client object implemented as a Celluloid Actor. The reason for this is because Celluloid Actor objects can be supervised, block threads and be accessed from multiple threads simultaneously without the need to implement any special locking or waiting mechanisms.

Additionally, all replies are cached internally to limit the number of calls to the router API. This is done because the API is rather slow which would make any calls using this library wait for several seconds for a reply. These replies are cached inside Celluloid actors so that multiple, seemingly parallel requests will get the same response object. Caching can be overridden by forcing the call through to the router. Otherwise, the reply becomes invalid within a couple of seconds so that the next call will go through to the router and fetch any updates. Think of it as a cheap rate-limiter.

## Copyright

Ruby-Dovado © 2015 by [Jan Lindblom](mailto:janlindblom@fastmail.fm).
Ruby-Dovado is licensed under the MIT license. Please see the
{file:LICENSE.txt} file for more information.

The Dovado, Dovado Tiny, Dovado Go, Dovado Tiny AC et.al brands are © 2004 - 2015 Dovado FZ-LLC.

This library is neither endorsed nor supported by Dovado.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://bitbucket.org/janlindblom/ruby-dovado/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
