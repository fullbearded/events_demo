class Event < ApplicationUidRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  belongs_to :user
  belongs_to :project
  belongs_to :resource, polymorphic: true

  enum action: %i[
    add move remove close reopen assign rename edit reply change_deadline
  ]

  # TODO: filter by access
  scope :by_team, ->(team_uid, _user) { where(project_id: Project.where(team_uid: team_uid).pluck(:id)) }

  scope :search, lambda { |opts|
    [User, Project].each do |model|
      key = model.to_s.downcase
      uid_key = "#{key}_uid".to_sym
      opts["#{key}_id".to_sym] = model.find_by(uid: opts[uid_key]) if opts[uid_key].present?
    end
    where(opts.slice(:user_id, :project_id))
  }

  def action_display
    send("#{resource_type.downcase}_#{action}_action_display")
  end

  def resource_name_display
    send("#{resource_type.downcase}_resource_name")
  end

  def resource_detail
    @resource_detail ||= send("#{resource_type.downcase}_resource_detail")
  end

  private

  def comment_add_action_display
    "#{Event.actions_i18n[:reply]} #{resource.todo.model_name.human}"
  end

  def todo_change_deadline_action_display
    parsed_extras = extras.load
    deadline_translate parsed_extras[:from], parsed_extras[:to]
  end

  def deadline_translate(from, to)
    configuration = { true_false: :close, false_true: :add, true_true: :assign }
    key = configuration["#{from.present?}_#{to.present?}".to_sym]
    I18n.t "todo_change_deadline_action_display.#{key}",
           from: Utils::Time.new(from).format, to: Utils::Time.new(to).format, resource_name: resource_name
  end

  def todo_assign_action_display
    parsed_extras = extras.load
    users = User.where(id: parsed_extras.values).each_with_object({}) { |v, h| h[v.id] = v; }
    assign_translate users[parsed_extras[:assigner_id]], users[parsed_extras[:assignee_id]]
  end

  def assign_translate(assigner, assignee)
    configuration = { /\d+_0$/ => :close, /^0_\d+/ => :add, /\d+_\d+/ => :assign }
    key = configuration.find { |reg, _v| "#{assigner.try(:id).to_i}_#{assignee.try(:id).to_i}".match reg }.last
    I18n.t "todo_assign_action_display.#{key}",
           assignee_name: assignee.try(:name), assigner_name: assigner.try(:name), resource_name: resource_name
  end

  def comment_resource
    resource.todo
  end

  def comment_resource_name
    comment_resource.model_name.human
  end

  def comment_resource_detail
    url = url_helpers.project_todo_path(comment_resource.project_uid, comment_resource)
    {
      name: resource.todo.name,
      content: resource.content,
      link: "#{url}##{resource.uid}"
    }
  end

  def todo_resource_detail
    default_detail.merge(link: url_helpers.project_todo_path(resource.project_uid, resource))
  end

  def todolist_resource_detail
    default_detail.merge(link: url_helpers.project_todolist_path(resource.project_uid, resource))
  end

  def team_resource_detail
    default_detail.merge(link: url_helpers.team_projects_path(resource))
  end

  def project_resource_detail
    default_detail.merge(link: url_helpers.team_project_path(resource.team_uid, resource))
  end

  def default_detail
    { name: resource.name, content: nil }
  end

  def resource_name
    resource_type.constantize.model_name.human
  end

  # NOTE: if the resource has special display, need generate a special method,
  #       such as: comment_add_action_display or todo_assign_resource_display
  %i[todo todolist project team].each do |type|
    # resource model name
    define_method "#{type}_resource_name" do
      resource_name
    end

    # resource action name
    %i[add remove close edit move].each do |action|
      define_method "#{type}_#{action}_action_display" do
        "#{action_i18n} #{resource_name}"
      end
    end
  end
end
