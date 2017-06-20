require 'rails_helper'

describe SessionController do
  let(:password) { '123456' }
  let(:tom) { create(:user, name: 'tom', password: password, password_confirmation: password) }

  context '#create' do
    it 'if password & user is correct, should redirect to root_url' do
      post :create, params: {username: tom.mobile, password: password}
      expect(response).to redirect_to(root_path)
    end

    it 'if password is invalid, should return to back page' do
      @request.env['HTTP_REFERER'] = login_path
      post :create, params: {username: tom.mobile, password: "#{password}1"}
      expect(response).to redirect_to(login_path)
    end
  end

end