class CreateAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :accesses, comment: 'user for project permission' do |t|
      t.references :user
      t.references :project
      t.references :role_id
      t.timestamps
    end
  end
end
