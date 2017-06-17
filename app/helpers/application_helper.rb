# frozen_string_literal: true

module ApplicationHelper
  def menu?(name)
    controller_name == name
  end
end
