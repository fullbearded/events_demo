class Project < ApplicationRecord
  belongs_to :team
  has_many :todolists
  has_many :todos

  has_many :events, as: :resource

  def generate_default_todolist!
    todolists.create! name: I18n.t(:default_todolist)
  end
end
