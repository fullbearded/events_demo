class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :name, null: false, default: '', comment: 'attachemnt file name'
      t.string :url, null: false, default: '', comment: 'attachement url: this is relative url'
      t.integer :category, null: false, default: 0, comment: 'category 0 image 1 download file'
      t.references :attachable, polymorphic: true, index: true, comment: 'every model: has_many :ref_nam, as: :attachable'
      t.timestamps
    end
  end
end
