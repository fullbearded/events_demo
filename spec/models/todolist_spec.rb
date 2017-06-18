require 'rails_helper'

describe Todolist do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) { create(:team, operator: tom) }
  before :each do
    project = team.generate_project! tom, name: 'Todolist', description: 'project for Todolist'
    project.operator = tom
    @todolist = project.generate_todolist!('todolist1')
  end

  context 'callback' do
    it 'if todolist destroyed, will create the remove event' do
      @todolist.destroy
      expect(@todolist.events.remove.exists?).to be_truthy
    end
  end

  context '#generate_todos!' do
    it 'will create the new todo && will trigger a add todo event' do
      todo = @todolist.generate_todos!(tom, name: 'todo1', description: 'from todolist generate todo')
      expect(todo.events.add.exists?).to be_truthy
    end
  end
end