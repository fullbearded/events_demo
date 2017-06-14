# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'teams unique id'
      t.timestamps
    end
  end
end
