# Cinch::Plugins::Karma

Cinch PLugin to track Karma.

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
