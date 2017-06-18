class CreateEventAssigners < ActiveRecord::Migration[5.0]
  def change
    create_table :event_assigners do |t|
      t.references :event, null: false, default: 0
      t.references :resource, polymorphic: true, index: true, comment: 'resources'
      t.integer :assigner_id, null: false, default: 0
      t.integer :assignee_id, null: false, default: 0
      t.timestamps
    end
  end
end
