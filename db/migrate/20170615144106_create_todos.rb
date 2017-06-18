class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos, comment: 'the todo tasks' do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name, null: false, default: '', comment: 'name'
      t.text :description
      t.integer :priority, null: false, default: 0, comment: 'task priority'
      t.integer :status, null: false, default: 0, comment: '0 add 1 close'
      t.datetime :deadline
      t.integer :assignee_id, null: false, default: 0

      t.references :user,  null: false, default: 0, comment: 'create user'
      t.references :todolist, null: false, default: 0
      t.references :project, null: false, default: 0
      t.string :project_uid, null: false, default: '', comment: 'redundancy column, project_uid'
      t.references :tag, null: false, default: 0
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :todos, :deleted_at
  end
end
