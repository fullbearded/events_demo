class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name, null: false, default: '', comment: 'team name'
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :teams, :deleted_at
  end
end
