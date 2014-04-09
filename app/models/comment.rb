class Comment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :article
  has_ancestry

  # Validations
  validates :content, presence: true
end
