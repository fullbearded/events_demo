class Project < ApplicationRecord
  acts_as_paranoid

  belongs_to :team
  has_many :todolists
  has_many :todos

  has_many :events, as: :resource
  attr_accessor :creator
  after_save -> (obj) { trigger_add_event user_uid: obj.creator.uid, project_uid: obj.uid }

  def generate_default_todolist!
    todolists.create! name: I18n.t(:default_todolist), user_id: creator.id, creator: creator
  end
end
