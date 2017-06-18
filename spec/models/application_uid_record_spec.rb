require 'rails_helper'

describe ApplicationUidRecord do
  it 'every inherited model, the instance will create uid' do
    user = create(:user)
    expect(user.uid.present?).to be_truthy
  end
end