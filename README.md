# Cinch::Plugins::Karma

[![Gem Version](https://badge.fury.io/rb/cinch-karma.png)](http://badge.fury.io/rb/cinch-karma)
[![Dependency Status](https://gemnasium.com/bhaberer/cinch-karma.png)](https://gemnasium.com/bhaberer/cinch-karma)
[![Build Status](https://travis-ci.org/bhaberer/cinch-karma.png?branch=master)](https://travis-ci.org/bhaberer/cinch-karma)
[![Coverage Status](https://coveralls.io/repos/bhaberer/cinch-karma/badge.png?branch=master)](https://coveralls.io/r/bhaberer/cinch-karma?branch=master)
[![Code Climate](https://codeclimate.com/github/bhaberer/cinch-karma.png)](https://codeclimate.com/github/bhaberer/cinch-karma)

Cinch Plugin to track Karma.

## Installation

Add this line to your application's Gemfile:

    gem 'cinch-karma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-karma

## Usage

Just add the plugin to your list:

    @bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [Cinch::Plugins::Karma]
      end
    end

Then in channel use the following commands:

    item++ || item--

    .karma item

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
