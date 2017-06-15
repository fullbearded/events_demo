class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos, comment: 'the tasks' do |t|
      t.string :title, null: false, default: '', comment: 'task title'
      t.text :description
      t.integer :priority, null: false, default: 0, comment: 'task priority'
      t.references :project, null: false, default: 0
      t.references :tag, null: false, default: 0
      t.timestamps
    end
  end
end
