class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  attr_accessible :title, :description, :body, :active, :user_id, :category_id
  validates_presence_of :title, :description
  validates_numericality_of :user_id, :category_id

  scope :inactive, where( active: false )
  scope :active, where( active: true )
end
