class Project < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :team
  has_many :todolists
  has_many :todos

  validates_presence_of :name

  has_many :events, as: :resource
  attr_accessor :operator
  after_create -> (obj) {
    trigger_add_event user_id: obj.operator.try(:id).to_i, project_id: obj.id
  }
  after_destroy -> (obj) {
    trigger_remove_event user_id: obj.operator.try(:id).to_i, project_id: obj.id
  }

  def generate_default_todolist!
    todolists.create! name: I18n.t(:default_todolist), user_id: operator.id, operator: operator
  end
end
