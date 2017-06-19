require 'rails_helper'

describe Project do
  context '#generate_todolist!' do
    let(:tom) { create(:user, name: 'tom') }
    let(:project) { create(:project, operator: tom) }
    it 'if create a new todolist, will get the add event trigger' do
      todolist = project.generate_todolist!('new_todolist')
      expect(todolist.events.add.exists?).to be_truthy
    end
  end
end