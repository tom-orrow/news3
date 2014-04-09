class CreateCategoriesUsersTable < ActiveRecord::Migration
  def change
    create_table :categories_users, id: false do |t|
      t.references :category
      t.references :user
    end
    add_index :categories_users, [:category_id, :user_id], unique: true
    add_index :categories_users, :category_id
  end
end
