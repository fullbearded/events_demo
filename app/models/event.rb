class Event < ApplicationUidRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  belongs_to :user
  belongs_to :project

  ROUTES_RELATION = {todo: :project_todo_path, todolist: :project_todolist_path, project: :team_project_path, team: :team_projects}.freeze

  belongs_to :resource, polymorphic: true
  enum action: %i(add move remove close reopen assign rename edit reply change_deadline)

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
    message = -> (from, to) {
      configuration = {true_false: :close, false_true: :add, true_true: :assign}
      key = configuration["#{from.present?}_#{to.present?}".to_sym]
      I18n.t "todo_change_deadline_action_display.#{key}",
             from: format_deadline_display(from), to: format_deadline_display(to), resource_name: resource_name
    }
    parsed_extras = extras.load
    message.call parsed_extras[:from], parsed_extras[:to]
  end

  def format_deadline_display(time)
    no_deadline_set = I18n.t(:no_deadline_set)
    time.nil? ? no_deadline_set : I18n.l(Time.parse(time))
  end

  def todo_assign_action_display
    message = -> (assigner, assignee) {
      configuration = {/\d+_0$/ => :close, /^0_\d+/ => :add, /\d+_\d+/ => :assign}
      key = configuration.find{|reg, v| "#{assigner.try(:id).to_i}_#{assignee.try(:id).to_i}".match reg}.last
      I18n.t "todo_assign_action_display.#{key}",
             assignee_name: assignee.try(:name), assigner_name: assigner.try(:name), resource_name: resource_name
    }
    parsed_extras = extras.load
    users = User.where(id: parsed_extras.values).inject({}) {|h, v| h[v.id] = v; h}
    message.call users[parsed_extras[:assigner_id]], users[parsed_extras[:assignee_id]]
  end

  def comment_resource_name
    resource.todo.model_name.human
  end

  def comment_resource_detail
    url = url_helpers.project_todo_path(resource.todo.project_uid, resource.todo)
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
    {name: resource.name, content: nil}
  end

  def resource_name
    resource_type.constantize.model_name.human
  end

  # NOTE: if the resource has special display, need generate a special method,
  #       such as: comment_add_action_display or todo_assign_resource_display
  %i(todo todolist project team).each do |type|

    # resource model name
    define_method "#{type}_resource_name" do
      resource_name
    end

    # resource action name
    %i(add remove close edit move).each do |action|
      define_method "#{type}_#{action}_action_display" do
         "#{action_i18n} #{resource_name}"
      end
    end
  end

end
