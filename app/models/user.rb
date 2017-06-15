class User < ApplicationRecord
  rolify
  authenticates_with_sorcery!
  has_and_belongs_to_many :teams

  belongs_to :user_group
end
