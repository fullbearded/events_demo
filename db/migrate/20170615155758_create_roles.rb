class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name
      t.timestamps null: false
    end
    add_index(:roles, :name)
  end
end
