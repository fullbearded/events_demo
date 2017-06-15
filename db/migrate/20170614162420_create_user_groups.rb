class CreateUserGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :user_groups, comment: 'user group' do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :name, null: false, default: '', limit: 50, comment: 'group name'
      t.timestamps null: false
    end
  end
end
