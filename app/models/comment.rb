class Comment < ApplicationRecord
  has_many :attachments, class_name: 'Attachment', as: :attachable
  belongs_to :user

  has_many :events, as: :resource
end
