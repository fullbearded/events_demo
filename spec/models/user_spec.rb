require 'rails_helper'

describe User do
  context '#validate' do
    context 'password' do
      it 'be ge 6, if not will get the too short error' do
        user = build(:user, password: '1' * 5)
        user.save
        expect(user.errors.messages[:password].first).to eq('密码过短（最短为 6 个字符）')
      end

      it 'be ge 16, if not will get the too long error' do
        user = build(:user, password: '1' * 17)
        user.save
        expect(user.errors.messages[:password].first).to eq('过长（最长为 16 个字符）')
      end

      it 'regex [0-9a-zA-Z]+, if not will get the invalid error' do
        user = build(:user, password: '&' * 6)
        user.save
        expect(user.errors.messages[:password].first).to eq('是无效的')
      end

      it 'be presence, if not will get the presence error' do
        user = build(:user, password: '')
        user.save
        expect(user.errors.messages[:password].first).to eq('不能为空')
      end

      it 'need confirmation' do
        user = build(:user, password: '1234567')
        user.save
        expect(user.errors.messages[:password_confirmation].first).to eq('两次输入密码不一致')
      end
    end
  end
end