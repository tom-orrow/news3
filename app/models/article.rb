class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  attr_accessible :title, :description, :body, :active

  def self.get_active
    Article.where( active: true )
  end
end
