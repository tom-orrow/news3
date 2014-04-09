class Article < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  extend FriendlyId

  friendly_id :title, use: :slugged
  self.per_page = 4

  default_scope { order('updated_at DESC') }

  # Associations
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy
  mount_uploader :title_pic, TitlepicUploader
  acts_as_taggable

  # Validations
  validates :title, :description, presence: true
  validates :description, length: { minimum: 15, maximum: 130 }
  validates :title, length: { minimum: 15, maximum: 90 }
  validates :user_id, numericality: true
  validate :require_at_least_one_category

  # Scopes
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }

  def send_article_confirmed_message
    ArticleMailer.delay.article_confirmed_message(self)
  end

  def send_article_rejected_message(reason)
    ArticleMailer.delay.article_rejected_message(self, reason)
  end

  def send_notification_to_subscribers
    checked_subscribers = [self.user]
    categories = self.categories.each do |category|
      subscribers = category.users - checked_subscribers
      checked_subscribers << subscribers
      subscribers.each { |subscriber| ArticleMailer.delay.new_article_message(self, category, subscriber) }
    end
  end

  private

  def self.search(params)
    tire.search(load: { include: :user }, page: (params[:page] || 1), per_page: self.per_page) do
      query { string params[:q] } if params[:q].present?
      sort { by :updated_at, 'desc' }
      filter :term, active: true
    end
  end

  # HACK: Use category.find() instead
  def self.by_category(category_id)
    if category_id
      joins('RIGHT JOIN articles_categories ac ON articles.id = ac.article_id')
        .where('ac.category_id = ?', category_id)
    else
      all()
    end
  end

  def require_at_least_one_category
    errors.add :base, 'Article requires at least one category selected.' if categories.blank?
  end
end
