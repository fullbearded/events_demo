class EventAssigner < ApplicationIdRecord
  belongs_to :resource, polymorphic: true

  belongs_to :assigner, class_name: 'User', foreign_key: :assigner_id
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
end
