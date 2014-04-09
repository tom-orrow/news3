class Article < ActiveRecord::Base
  include ThinkingSphinx::Scopes
  extend FriendlyId

  friendly_id :title, use: :slugged

  ACTION_LIMITS = {
    index: [26, 12],
    list: [12, 12]
  }

  default_scope { order('updated_at DESC') }

  # Associations
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy
  mount_uploader :title_pic, TitlepicUploader
  acts_as_taggable
  is_impressionable

  # Validations
  validates :title, length: { minimum: 15, maximum: 90 }
  validates :description, length: { minimum: 15, maximum: 200 }
  validates :user_id, numericality: true
  validate :require_at_least_one_category

  # Scopes
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }
  scope :action_limit, (lambda do |parent_action, page = nil|
    if page
      limit(ACTION_LIMITS[parent_action][1]).offset(ACTION_LIMITS[parent_action][0] + ACTION_LIMITS[parent_action][1] * page)
    else
      limit(ACTION_LIMITS[parent_action][0])
    end
  end)

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
