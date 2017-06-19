require 'rails_helper'

describe Todo do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  let(:project) { create(:project, operator: tom) }
  let(:todolist) {create(:todolist, operator: tom)}
  let(:todo) { create(:todo, user_id: tom.id, project_id: project.id,
                      project_uid: project.uid, operator: tom, todolist_id: todolist.id) }

  context '#callback' do
    it 'after create a new todo, should get a add event' do
      expect(todo.events.add.exists?).to be_truthy
    end

    it 'after destory a new todo, should get a remove event' do
      todo.destroy
      expect(todo.events.remove.exists?).to be_truthy
    end
  end

  context '#to_reopen!' do
    it 'will change the todo status to add' do
      todo.to_close!
      todo.to_reopen!
      expect(todo.reload.status).to eq('add')
    end

    it 'should get a reopen event' do
      todo.to_reopen!
      expect(todo.events.reopen.exists?).to be_truthy
    end
  end

  context '#to_close!' do
    before :each do
      todo.to_close!
    end
    it 'will change the todo status to add' do
      expect(todo.reload.status).to eq('close')
    end

    it 'should get a close event' do
      expect(todo.events.close.exists?).to be_truthy
    end
  end

  context '#to_assign!' do
    before :each do
      todo.to_assign!(0, tom.id)
    end
    it 'should update the assignee for todo' do
      expect(todo.assignee.name).to eq(tom.name)
    end

    it 'should get a assign event' do
      expect(todo.events.assign.exists?).to be_truthy
    end
  end

  context '#to_move!' do
    before :each do
      @default_todolist = project.todolists.first
      todo.to_move! @default_todolist.id
    end
    it 'should update the todolist to direct todolist' do
      expect(todo.todolist.id).to eq(@default_todolist.id)
    end

    it 'should get a move event' do
      expect(todo.events.move.exists?).to be_truthy
    end
  end

  context '#to_change_deadline!' do
    before :each do
      @time = Time.parse '2018-01-01 00:00'
      todo.to_change_deadline! nil, @time
    end

    it 'should update the deadline' do
      expect(todo.deadline).to eq(@time)
    end

    it 'should get a change_deadline event' do
      expect(todo.events.change_deadline.exists?).to be_truthy
    end
  end

  context '#generate_comments!' do
    before :each do
      todo.generate_comments! tom, content: 'I love superman'
    end

    it 'should create a comment' do
      expect(todo.comments.count).to eq(1)
    end

    it 'should get a comment add event' do
      expect(todo.comments.first.events.add.exists?).to be_truthy
    end
  end
end