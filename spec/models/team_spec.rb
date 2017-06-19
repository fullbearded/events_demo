require 'rails_helper'

describe Team do
  let(:tom) { create(:user, name: 'tom') }
  let(:new_team) {create(:team, name: 'new_team', operator: tom)}
  context '#validates' do
    it 'if name is blank, should get the blank error message' do
      team = build(:team, name: nil, operator: tom)
      team.save
      expect(team.errors.messages[:name].first).to eq('不能为空')
    end
  end

  context '#callback' do
    it 'if a new team created, should create a add event for team' do
      team = create(:team, operator: tom, name: 'callback')
      expect(team.events.add.exists?).to be_truthy
    end
  end

  context '#generate_project!' do
    it 'should get a project' do
      project_name = 'team_project'
      new_team.generate_project!(tom, name: project_name)
      expect(new_team.projects.exists? name: project_name).to be_truthy
    end

    it 'should get a default todolist' do
      project_name = 'team_project'
      new_team.generate_project!(tom, name: project_name)
      project = new_team.projects.find_by name: project_name
      expect(project.todolists.count).to eq(1)
    end
  end

end