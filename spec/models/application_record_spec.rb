require 'rails_helper'

describe ApplicationRecord do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) { create(:team, operator: tom) }
  before :each do
    @project = team.generate_project! tom, name: 'project1', description: 'this is rspec project1'
  end

  context '#trigger_add_event' do
    it 'when project created, will create a add event' do
      expect(@project.events.add.exists?).to be_truthy
    end
  end

  context '#trigger_remove_event' do
    it 'when project destroy, will create a remove event' do
      @project.destroy
      expect(@project.events.remove.exists?).to be_truthy
    end
  end
end