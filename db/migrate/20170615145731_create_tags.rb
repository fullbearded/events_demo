class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, default: ''
      t.references :team, null: false, default: 0
      t.timestamps
    end
  end
end
