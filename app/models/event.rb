class Event < ApplicationRecord
  belongs_to :user
  belongs_to :project

  belongs_to :resource, polymorphic: true
  enum action: %i(add move remove close reopen assign rename edit reply)

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

  def action_display
    comment_add? ? Event.actions_i18n[:reply] : action_i18n
  end

  def resource_display
    comment_add? ? resource.todo.model_name.human : resource_type.constantize.model_name.human
  end

  def resource_detail
    @resource_detail ||= comment_add? ? {name: resource.todo.name, content: resource.content} : {name: resource.name}
  end
  
  private

  def comment_add?
    comment_resource? && add?
  end

  def comment_resource?
    resource_type == 'Comment'
  end

end
