require 'rails_helper'

describe LaunchpadController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  context '#index' do
    before :each do
      team.users << tom
      allow(controller).to receive(:current_user) { tom }
    end

    it 'if team save failure, should get unprocessable_entity http code' do
      get :index, session: {team_id: team.id}
      assert_equal tom.teams, assigns(:teams)
    end
  end
end