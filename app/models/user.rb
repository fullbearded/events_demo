class User < ApplicationUidRecord
  authenticates_with_sorcery!

  validates :password, presence: true, confirmation: true,
                       length: { minimum: 6, maximum: 16 },
                       format: { with: /\A([0-9a-zA-Z]+)\Z/i, on: :create }
  validates :password_confirmation, presence: true

  has_and_belongs_to_many :teams
  belongs_to :user_group
  has_many :todos
  has_many :projects
  has_many :todolists
end
