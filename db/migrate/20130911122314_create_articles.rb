class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :description
      t.text :body
      t.boolean :active, null: false, default: false
      t.string :slug
      t.boolean :delta, default: true, null: false
      t.string :title_pic
      t.belongs_to :user

      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
