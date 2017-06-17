class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :tag
  has_many :comments
  belongs_to :user

  has_many :events, as: :resource

  def generate_comments!(user, opts = {})
    keep_transaction do
      comment = comments.create!(opts.merge(user_id: user.id))
      comment.events.build(project_uid: project_uid, user_uid: user.uid).save!
    end
  end
end
