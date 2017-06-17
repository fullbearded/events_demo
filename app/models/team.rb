# frozen_string_literal: true

class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :projects
  has_many :tags

  has_many :events, as: :resource

  def generate_project!(name, opts = {})
    keep_transaction do
      project = projects.create({name: name, team_uid: uid}.merge(opts))
      project.generate_default_todolist!
    end
  end

end
