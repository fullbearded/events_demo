class Comment < ApplicationUidRecord
  acts_as_paranoid without_default_scope: true

  has_many :attachments, class_name: 'Attachment', as: :attachable
  belongs_to :user
  belongs_to :todo

  has_many :events, as: :resource
  attr_accessor :operator
  after_create lambda { |obj|
    trigger_add_event user_id: obj.operator.try(:id).to_i,
                      project_id: obj.todo.project_id
  }
  after_destroy lambda { |obj|
    trigger_remove_event user_id: obj.operator.try(:id).to_i,
                         project_id: obj.todo.project_id
  }
end
