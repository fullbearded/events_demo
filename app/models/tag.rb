class Tag < ApplicationIdRecord
  has_many :todos
  belongs_to :team
end
