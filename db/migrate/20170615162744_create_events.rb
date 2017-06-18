class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.references :resource, polymorphic: true, index: true, comment: 'event resources'
      t.integer :action, null: false, default: 0, limit: 1, comment: 'resource action, such as todo assign etc.'
      t.references :user, null: false, default: 0, comment: 'event author, user creater'
      t.references :project, null: false, default: 0, comment: 'belongs_to project'
      t.text :extras, comment: 'store resources practical attributes'
      t.timestamps
    end
  end
end
