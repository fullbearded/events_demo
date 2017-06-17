class CreateTodolists < ActiveRecord::Migration[5.0]
  def change
    create_table :todolists do |t|
      t.string :uid, null: false, default: '', limit: 32
      t.string :name, null: false, default: '', limit: 50
      t.references :project, null: false, default: 0
      t.references :user,  null: false, default: 0, comment: 'create user'
      t.timestamps
    end
  end
end
