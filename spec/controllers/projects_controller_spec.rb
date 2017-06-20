require 'rails_helper'

describe ProjectsController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  let(:project) { create(:project, operator: tom, team_uid: team.uid) }
  before :each do
    allow(controller).to receive(:current_user) { tom }
  end
  context '#index' do
    it 'should get projects' do
      get :index, params: {team_uid: team.uid}, session: {team_id: team.id}
      assert_equal team.projects, assigns(:projects)
    end
  end

  context '#show' do
    it 'should get projects' do
      get :show, params: {team_uid: team.uid, uid: project.uid}, session: {team_id: team.id}
      assert_equal project, assigns(:project)
    end
  end
end