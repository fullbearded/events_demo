# frozen_string_literal: true

class ApplicationUidRecord < ApplicationRecord
  before_create :generate_uid

end
