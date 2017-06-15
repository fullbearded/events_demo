class SorceryCore < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid, null: false, default: '', limit: 32, comment: 'unique id'
      t.string :crypted_password, null: false, default: ''
      t.string :salt, null: false, default: ''

      t.string :name, null: false, default: '', limit: 30, comment: 'user name'
      t.string :email, null: false, default: '', limit: 100, comment: 'user email'
      t.string :mobile, null: false, default: '', limit: 11, comment: 'user mobile'
      t.string :remark, null: false, default: '', limit: 255, comment: 'user remark'

      t.references :user_group, null: false, default: 0
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
