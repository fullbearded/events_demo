require 'rails_helper'

describe Comment do
  let(:tom) { create(:user, name: 'tom') }
  let(:todo) { create(:todo, operator: tom) }
  let(:comment) { create(:comment, operator: tom, todo_id: todo.id, user_id: tom.id) }
  context '#callback' do
    it 'after create a new comment, should get a add event' do
      expect(comment.events.add.exists?).to be_truthy
    end

    it 'after destory a new comment, should get a remove event' do
      comment.destroy
      expect(comment.events.remove.exists?).to be_truthy
    end
  end
end