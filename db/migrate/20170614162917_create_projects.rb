class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name, null: false, default: '', limit: 255, comment: 'name'
      t.string :description, null: false, default: '', limit: 500, comment: 'description'
      t.boolean :guest_lockable, null: false, default: false, comment: 'hide sensitive content'
      t.integer :project_type, null: false, default: 0, comment: 'project type: 0 standard, 1 pipeline'
      t.boolean :publishable, null: false, default: false, comment: 'everyone can visit project'

      t.references :team, null: false, default: 0, primary_key: :team_uid
      t.string :team_uid, null: false, default: '', limit: 32, comment: 'redundancy column, team_uid'
      t.timestamps null: false
    end
    add_index :projects, [:team_id, :name], unique: true
  end
end
