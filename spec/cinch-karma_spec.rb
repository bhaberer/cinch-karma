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

  it 'should allow users to add karma mid message' do
    msg = make_message(@bot, 'd asd asdasd foo++ dasdasd sadasd sad', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is 1"
  end

  it 'should allow users to add karma with items with spaces via ()' do
    msg = make_message(@bot, '(foo bar)++', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo bar', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo bar is 1"
  end

  it 'should allow users to remove karma' do
    msg = make_message(@bot, 'foo--', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is -1"
  end

  it 'should allow users to remove karma mid message' do
    msg = make_message(@bot, 'd asd asdasd foo-- dasdasd sadasd sad', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is -1"
  end

  it 'should allow users to remove karma with items with spaces via ()' do
    msg = make_message(@bot, '(foo bar)--', { :channel => '#foo' })
    get_replies(msg)
    msg = make_message(@bot, '!karma foo bar', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo bar is -1"
  end
  it 'should not allow users to check karam via pm' do
    msg = make_message(@bot, '!karma foo')
    get_replies(msg).first.should == "You must use that command in the main channel."
  end

  it 'should not allow users to add karma via pm' do
    msg = make_message(@bot, 'foo++')
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is 0"
  end

  it 'should not allow users to remove karma via pm' do
    msg = make_message(@bot, 'foo--')
    msg = make_message(@bot, '!karma foo', { :channel => '#foo' })
    get_replies(msg).first.should == "Karma for foo is 0"
  end
end
