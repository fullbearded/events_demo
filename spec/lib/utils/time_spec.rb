require 'rails_helper'

describe Utils::Time do
  context '::Const' do
    it 'default non time should get the correct response' do
      expect(Utils::Time::NON_TIME).to eq('没有截止日期')
    end
  end

  context '#format' do
    it 'if assign time is nil, should return non time' do
      expect(Utils::Time.new(nil).format).to eq('没有截止日期')
    end

    it 'if assign time is correct datetime, should return the format datetime string' do
      time = Time.parse('2017-06-19 10:19:51 +0800')
      expect(Utils::Time.new(time.to_s).format).to eq(time.strftime('%F %T'))
    end
  end
end