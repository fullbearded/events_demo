require 'rails_helper'

describe ApplicationController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}

  controller do
    def index
      current_team
      current_user
      if params[:redirect_to].blank?
        halt! 'error', params[:error_redirect_to]
      else
        redirect_to_with_success 'success', params[:redirect_to]
      end

    end
  end

  context 'require current_user' do
    before(:each) do
      team.users << tom
      allow(controller).to receive(:current_user) { tom }
    end

    context '#require_team' do
      it 'if session team id is blank, should get the redirect address' do
        get :index
        expect(response).to redirect_to(launchpad_index_path)
      end
    end

    context '#current_team' do
      it 'if choose the team is created by tom, should return the tom team' do
        get :index, params: {redirect_to: launchpad_index_path}, session: {team_id: team.id}
        assert_equal team, assigns(:current_team)
      end
    end

    context '#redirect_to_with_success' do
      it 'should get a success redirect url' do
        get :index, params: {redirect_to: launchpad_index_path}, session: {team_id: team.id}
        expect(response).to redirect_to(launchpad_index_path)
      end
    end

    context '#redirect_to_with_failed' do
      it 'should get a error reddirect url' do
        get :index, params: {error_redirect_to: launchpad_index_path}, session: {team_id: team.id}
        expect(response).to redirect_to(launchpad_index_path)
      end
    end

    context 'format_page' do
      it 'should return 1, if params page is blank' do
        get :index, params: {redirect_to: launchpad_index_path}, session: {team_id: team.id}
        expect(controller.format_page).to eq(1)
      end

      it 'should return 100, if params page over 100' do
        get :index, params: {page: 101, redirect_to: launchpad_index_path}, session: {team_id: team.id}
        expect(controller.format_page).to eq(100)
      end
    end
  end

  context '#current_user' do
    before(:each) do
      team.users << tom
    end

    it 'should return the tom' do
      get :index, session: {user_id: tom.id}
      assert_equal tom, assigns(:current_user)
    end
  end

  context '#not_authenticated' do
    it 'should get the login url' do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end
end