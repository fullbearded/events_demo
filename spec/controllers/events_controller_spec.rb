require 'rails_helper'

describe EventsController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  let(:project) { create(:project, operator: tom) }
  let(:todolist) {create(:todolist, operator: tom)}
  let(:todo) { create(:todo, user_id: tom.id, project_id: project.id,
                      project_uid: project.uid, operator: tom, todolist_id: todolist.id) }

  context '#index' do
    before :each do
      allow(controller).to receive(:current_user) { tom }
    end

    it 'should get event' do
      get :index, params: {team_uid: team.uid}, session: {team_id: team.id}
      assert_equal Event.where(project_id: team.projects.pluck(:id)).to_a, assigns(:events)
    end
  end
end