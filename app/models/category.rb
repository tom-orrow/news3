class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :users

  before_destroy do
    articles.clear
    users.clear
  end
end
