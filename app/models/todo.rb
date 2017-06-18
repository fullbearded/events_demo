class Todo < ApplicationUidRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :project
  belongs_to :tag
  has_many :comments
  belongs_to :user

  has_one :assignee, -> { where(resource_type: Todo.name).order(id: :desc)},
          class_name: 'EventAssigner', foreign_key: :resource_id
  has_many :event_assigners, as: :resource

  has_many :events, as: :resource
  attr_accessor :operator
  after_create -> (obj) {
    trigger_add_event user_id: obj.operator.try(:id).to_i, project_id: project_id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.try(:id).to_i, project_id: project_id
  }

  enum status: {add: 0, close: 1}

  # special action
  def to_close!
    keep_transaction do
      close!
      events.close.build(user_id: operator.try(:id).to_i, project_id: project_id).save!
    end
  end

  def to_assign!(assigner_id, assignee_id)
    keep_transaction do
      event = events.assign.create!(user_id: operator.try(:id).to_i, project_id: project_id)
      event_assigners.build(assigner_id: assigner_id, assignee_id: assignee_id, event_id: event.id).save!
    end
  end

  def to_move!(direct_todolist_id)
    keep_transaction do
      update todolist_id: direct_todolist_id
      events.move.build(user_id: operator.try(:id).to_i, project_id: project_id).save!
    end
  end

  def generate_comments!(user, opts = {})
    comments.create!(opts.merge(user_id: user.id, operator: user))
  end
end
