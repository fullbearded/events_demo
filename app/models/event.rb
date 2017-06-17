class Event < ApplicationRecord
  belongs_to :resource, polymorphic: true
  enum action: %i(non add move remove close reopen assign rename)

  class << self
    def query(opts)
      self.where(opts)
    end
  end

end
