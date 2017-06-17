class Todolist < ApplicationRecord
  acts_as_paranoid

  has_many :todos
  belongs_to :project
  belongs_to :user

  has_many :events, as: :resource
  attr_accessor :operator
  after_save -> (obj) {
    trigger_add_event user_id: obj.operator.try(:id).to_i.to_i, project_id: obj.project_id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.try(:id).to_i, project_id: obj.project_id
  }

  def generate_todos!(user, opts = {})
    keep_transaction do
      attrs = {
        user_id: user.id, project_id: project_id,
        project_uid: project.uid, operator: user
      }.merge(opts)
      todos.create!(attrs)
    end
  end

end
