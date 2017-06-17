class Todolist < ApplicationRecord
  has_many :todos
  belongs_to :project
  belongs_to :user

  has_many :events, as: :resource

  def generate_todos!(user, opts = {})
    keep_transaction do
      todo = todos.create!(opts.merge(user_id: user.id, project_id: project_id, project_uid: project.uid))
      todo.events.add.build(project_uid: project.uid, user_uid: user.uid).save!
    end
  end

end
