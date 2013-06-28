require 'cinch'
require 'cinch-cooldown'
require 'cinch-storage'

module Cinch::Plugins
  class Karma
    include Cinch::Plugin

    enforce_cooldown

    self.help = 'Use .karma <item> to see it\'s karma level. You can use <item>++ or <item>-- [or (something with spaces)++] to alter karma for an item'

    listen_to :channel

    match /karma (.+)/
    match /k (.+)/

    def initialize(*args)
      super
      @storage = CinchStorage.new(config[:filename] || 'yaml/karma.yml')
    end

    def listen(m)
      if m.message.match(/\S+[\+\-]{2}/)
        channel = m.channel.name
        @storage.data[channel] = Hash.new unless @storage.data.key?(channel)
        updated = false

        m.message.scan(/.*?((\w+)|\((.+?)\))(\+\+|--)(\s|\z)/).each do |karma|
          if karma[0]
            item = karma[1] || karma[2]
            item.downcase!

            @storage.data[channel][item] = 0 unless @storage.data[channel].key?(item)

            if karma[3] == '++'
              @storage.data[channel][item] += 1
              updated = true
            elsif karma[3] == '--'
              @storage.data[channel][item] -= 1
              updated = true
            else
              debug 'something went wrong matching karma!'
            end
          end
        end

        if updated
          synchronize(:karma_save) do
            @storage.save
          end
        end
      end
    end

    def execute(m, item)
      if m.channel.nil?
        m.user.reply "You must use that command in the main channel."
        return
      end

      @storage.data[m.channel.name] = Hash.new unless @storage.data.key?(m.channel.name)
      karma = @storage.data[m.channel.name][item.downcase] || 0
      m.reply "Karma for #{item} is #{karma}"
    end
  end
end
