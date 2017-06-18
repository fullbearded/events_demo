# frozen_string_literal: true

class ApplicationUidRecord < ApplicationRecord
  self.abstract_class = true
  before_create :generate_uid
end
