class Comment < ApplicationRecord
  has_many :attachments, class_name: 'Attachment', as: :attachable
end
