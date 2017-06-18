# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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

  %w(add remove).each do |action|
    define_method "trigger_#{action}_event" do |opts = {}|
      self.events.send(action).build(opts).save
    end
  end

end
