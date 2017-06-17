class Comment < ApplicationRecord
  has_many :attachments, class_name: 'Attachment', as: :attachable
  belongs_to :user
  belongs_to :todo

  has_many :events, as: :resource
  attr_accessor :creator
  after_save -> (obj) {trigger_add_event user_uid: obj.creator.uid, project_uid: obj.todo.project_uid}
end
