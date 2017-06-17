class Comment < ApplicationRecord
  acts_as_paranoid

  has_many :attachments, class_name: 'Attachment', as: :attachable
  belongs_to :user
  belongs_to :todo

  has_many :events, as: :resource
  attr_accessor :operator
  after_save -> (obj) {
    trigger_add_event user_id: obj.operator.id, project_id: obj.todo.project_id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.id, project_id: obj.todo.project_id
  }
end
