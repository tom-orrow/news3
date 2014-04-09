class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :users
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent_category, class_name: "Category"

  before_destroy do
    articles.clear
    users.clear
  end
end
