class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :tag
  has_many :comments
  belongs_to :user

  has_many :events, as: :resource
  attr_accessor :creator
  after_save -> (obj) {trigger_add_event user_uid: obj.creator.uid, project_uid: project_uid}

  def generate_comments!(user, opts = {})
    comments.create!(opts.merge(user_id: user.id, creator: user))
  end
end
