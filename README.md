# Ruby-Dovado

A Dovado Router API for Ruby.

[![Build Status](https://drone.io/bitbucket.org/janlindblom/ruby-dovado/status.png)](https://drone.io/bitbucket.org/janlindblom/ruby-dovado/latest)
[![Gem](https://img.shields.io/gem/v/ruby-dovado.svg?style=flat-square)](https://rubygems.org/gems/ruby-dovado)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg?style=flat-square)](http://www.rubydoc.info/gems/ruby-dovado/frames)
[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square)](#copyright)

This library serves to enable easy access to the built in, Telnet-based, rudimentary API of the [routers from Dovado](http://www.dovado.com/en/products) running software version 7 and 8 (applies to the original Tiny, Go and Pro routers). It might work with the Tiny AC too but I have no means to test against that.

## Purpose

The original purpose of this library was to enable addition of router information about connection state, mobile data connection quality and data quota usage on a wall-mounted TV or a small touch screen connected to a Raspberry Pi, accessing a dashboard implemented using [Dashing](https://shopify.github.io/dashing/).

See this blog entry for some discussion on usage and background: "[A Ruby API for Dovado routers](http://www.janlindblom.se/blog/programming/2015/10/22/ruby-dovado-library.html)".

## Usage

Add it to your Gemfile:

```ruby
gem "ruby-dovado"
```

Then load it in your code:

```ruby
require "dovado"

router = Dovado::Router.new(address: "192.168.0.1", user: "admin", password: "password")
router.info
router.sms.load_messages
message = router.sms.get_message 12
```

The main elements available on the `router` object are:

* `info` - [Dovado::Router::Info](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Info)
* `services` - [Dovado::Router::Services](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Services)
* `internet` - [Dovado::Router::Internet](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Internet)
* `sms` - [Dovado::Router::Sms](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Sms)
* `traffic` - [Dovado::Router::Traffic](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Traffic)
* `home_automation` - [Dovado::Router::Automation](http://www.rubydoc.info/gems/ruby-dovado/Dovado/Router/Automation)

For the full documentation, head over to [rubydoc.info](http://www.rubydoc.info/gems/ruby-dovado/frames).

## Design Considerations

Since the API published by these routers is Telnet-based, it stands to reason to limit simultaneous connections. This is achieved by a single client object implemented as a Celluloid Actor. The reason for this is because Celluloid Actor objects can be supervised, block threads and be accessed from multiple threads simultaneously without the need to implement any special locking or waiting mechanisms.

Additionally, all replies are cached internally to limit the number of calls to the router API. This is done because the API is rather slow which would make any calls using this library wait for several seconds for a reply. These replies are cached inside Celluloid actors so that multiple, seemingly parallel requests will get the same response object. Caching can be overridden by forcing the call through to the router. Otherwise, the reply becomes invalid within a couple of seconds so that the next call will go through to the router and fetch any updates. Think of it as a cheap rate-limiter.

## Limitations and Caveats

The API on the router supports only one active user/connection at once and this library doesn't (yet) care about that. This means you *will* run into problems if you connect from two clients at once, there will be an error raised by the client that isn't rescued anywhere, essentially killing the Actor managing the client and resulting in any subsequent calls raising new errors.

In a future version, this will most likely be fixed (by rescuing in the client and setting up a new Actor or something like that), but for now this is not really a priority for me. If you have a fix for it then by all means send me a pull request and I'll merge it.

This is not a concern for multiple instances of a running Ruby app using the library from parallel threads though, only in the case of separate instances running separate clients.

## Copyright

Ruby-Dovado © 2015-2016 by [Jan Lindblom](mailto:janlindblom@fastmail.fm).
Ruby-Dovado is licensed under the MIT license. Please see the
{file:LICENSE.txt} file for more information.

The Dovado, Dovado Tiny, Dovado Go, Dovado Tiny AC et.al brands are © 2004 - 2016 Dovado FZ-LLC.

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
