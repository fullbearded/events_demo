class Event < ApplicationRecord
  belongs_to :user
  belongs_to :project

  belongs_to :resource, -> { with_deleted }, polymorphic: true
  enum action: %i(add move remove close reopen assign rename)

  scope :by_team, -> (team_uid, user) do
    where(project_id: Project.with_deleted.where(team_uid: team_uid).pluck(:id))
  end

  scope :search, -> (opts) do
    [User, Project].each do |model|
      core_key = model.to_s.downcase
      opts["#{core_key}_id"] = mode.find_by(uid: opts["#{core_key}_uid"]) if opts["#{core_key}_uid"].present?
    end
    where(opts.slice(:user_id, :project_id))
  end

end
