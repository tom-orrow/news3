class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :description
      t.text :body
      t.boolean :active, null: false, default: false

      t.belongs_to :user

      t.timestamps
    end
  end
end
