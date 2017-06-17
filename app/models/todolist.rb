class Todolist < ApplicationRecord
  acts_as_paranoid

  has_many :todos
  belongs_to :project
  belongs_to :user

  has_many :events, as: :resource
  attr_accessor :creator
  after_save -> (obj) {
    trigger_add_event user_uid: obj.creator.uid, project_uid: obj.project.uid
  }

  def generate_todos!(user, opts = {})
    keep_transaction do
      attrs = {
        user_id: user.id, project_id: project_id,
        project_uid: project.uid, creator: user
      }.merge(opts)
      todos.create!(attrs)
    end
  end

end
