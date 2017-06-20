require 'rails_helper'

describe TodosController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  let(:project) { create(:project, operator: tom) }
  let(:todolist) {create(:todolist, operator: tom)}
  let(:todo) { create(:todo, user_id: tom.id, project_id: project.id,
                      project_uid: project.uid, operator: tom, todolist_id: todolist.id) }

  context '#show' do
    before :each do
      team.users << tom
      allow(controller).to receive(:current_user) { tom }
    end

    it 'should get todo' do
      get :show, params: {project_uid: todo.project_uid, uid: todo.uid}, session: {team_id: team.id}
      assert_equal todo, assigns(:todo)
    end
  end
end