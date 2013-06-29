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

        m.message.scan(/(\s|\A)(\w+|\(.+?\))(\+\+|--)(\s|\z)/).each do |karma|
          operation = karma[2]
          item      = karma[1].gsub(/\(|\)/, '').downcase

          @storage.data[channel][item] ||= 0

          case operation
          when '++'
            @storage.data[channel][item] += 1
          when '--'
            @storage.data[channel][item] -= 1
          end

          @storage.synced_save
        end
      end
    end

    def execute(m, item)
      return if sent_via_pm?(m)

      @storage.data[m.channel.name] ||= Hash.new
      karma = @storage.data[m.channel.name][item.downcase] || 0
      m.reply "Karma for #{item} is #{karma}"
    end

    def sent_via_pm?(m)
      if m.channel.nil?
        m.reply "You must use that command in the main channel."
        return true
      end
    end
  end
end
