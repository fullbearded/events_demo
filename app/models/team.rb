# frozen_string_literal: true

class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :projects
  has_many :tags
end
