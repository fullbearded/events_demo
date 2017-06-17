# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_create :generate_uid

  def generate_uid
    self.uid = SecureRandom.uuid.delete('-')
  end

  def to_param
    uid
  end

  def keep_transaction(&block)
    ActiveRecord::Base.transaction do
      block.call if block.present?
    end
  end

  def trigger_add_event(opts = {})
    self.events.add.build(opts).save
  end
  
end
