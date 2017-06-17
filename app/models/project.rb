class Project < ApplicationRecord
  acts_as_paranoid

  belongs_to :team
  has_many :todolists
  has_many :todos

  has_many :events, as: :resource
  attr_accessor :operator
  after_save -> (obj) {
    trigger_add_event user_id: obj.operator.id, project_id: obj.id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.id, project_id: obj.id
  }

  def generate_default_todolist!
    todolists.create! name: I18n.t(:default_todolist), user_id: operator.id, operator: operator
  end
end
