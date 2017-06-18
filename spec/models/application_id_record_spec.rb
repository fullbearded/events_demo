require 'rails_helper'

describe ApplicationUidRecord do
  it 'every inherited model, the instance have no uid' do
    user_group = create(:user_group)
    expect(user_group.attributes.has_key? :uid).to be_falsey
  end
end