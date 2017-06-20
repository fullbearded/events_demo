require 'rails_helper'

describe UsersController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  context '#index' do
    before :each do
      team.users << tom
      allow(controller).to receive(:current_user) { tom }
    end

    it 'should get the team users' do
      get :index, params: {team_uid: team.uid}, session: {team_id: team.id}
      assert_equal team.users, assigns(:users)
    end
  end
end