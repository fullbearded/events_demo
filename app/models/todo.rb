class Todo < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :tag
  has_many :comments
  belongs_to :user

  has_many :events, as: :resource
  attr_accessor :operator
  after_save -> (obj) {
    trigger_add_event user_id: obj.operator.try(:id).to_i, project_id: project_id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.try(:id).to_i, project_id: project_id
  }

  def generate_comments!(user, opts = {})
    comments.create!(opts.merge(user_id: user.id, operator: user))
  end
end
