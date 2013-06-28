require 'spec_helper'

describe Cinch::Plugins::Karma do
  include Cinch::Test

  before(:each) do
    @bot = make_bot(Cinch::Plugins::Karma, { :filename => '/dev/null' })
  end

  it 'should default to zero karma' do
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is 0"
  end

  it 'should allow users to add karma' do
    msg = make_message(@bot, 'foo++', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is 1"
  end
end
