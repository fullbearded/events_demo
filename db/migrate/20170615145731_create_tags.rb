class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name, null: false, default: ''
      t.references :team, null: false, default: 0
      t.timestamps
    end
  end
end
