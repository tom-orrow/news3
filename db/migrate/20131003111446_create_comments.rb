class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :user
      t.belongs_to :article
      t.string :ancestry

      t.timestamps
    end

    add_index :comments, :ancestry
  end
end
