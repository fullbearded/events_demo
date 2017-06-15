class Tag < ApplicationRecord
  has_many :todos
  belongs_to :team
end
