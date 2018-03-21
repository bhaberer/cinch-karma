# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/cooldown'
require 'cinch/storage'

module Cinch
  module Plugins
    # Cinch Plugin to monitor karma and report.
    class Karma
      include Cinch::Plugin

      enforce_cooldown

      self.help = 'Use .karma <item> to see it\'s karma level. You can use ' \
                  '<item>++ or <item>-- [or (something with spaces)++] to ' \
                  'alter karma for an item'

      listen_to :channel

      match(/(?:k|karma) (.+)/)

      def initialize(*args)
        super
        @storage = Cinch::Storage.new(config[:filename] || 'yaml/karma.yml')
      end

      def listen(m)
        return unless m.message.match(/\S+[\+\-]{2}/)
        channel = m.channel.name

        # Scan messages for multiple karma items
        m.message.scan(/(^|\s|\A|\b)(\w+|\(.+?\))(\+\+|--)(\s|\z|$)/).each do |k|
          process_karma(channel, k[1].gsub(/\(|\)/, '').downcase, k[2])
	  item = k[1].gsub(/\(|\)/, '')
	  @storage.synced_save(@bot)
	  m.reply "#{item} now has #{@storage.data[channel][item.downcase]} point(s) of karma"
        end
        @storage.synced_save(@bot)
      end

      def execute(m, item)
        return if sent_via_pm?(m)

        channel = m.channel.name
        item.downcase!
        init_karma(channel, item)

        m.reply "#{item} has #{@storage.data[channel][item]} point(s) of karma"
      end

      private

      def process_karma(channel, item, operation)
        # Ensure the item's Karma has been init
        init_karma(channel, item)

        case operation
        when '++'
          @storage.data[channel][item] += 1
        when '--'
          @storage.data[channel][item] -= 1
        end
      end

      def sent_via_pm?(m)
        return false unless m.channel.nil?
        m.reply 'You must use that command in the main channel.'
        true
      end

      def init_karma(channel, item = nil)
        @storage.data[channel] ||= {}
        @storage.data[channel][item] ||= 0 unless item.nil?
      end
    end
  end
end
