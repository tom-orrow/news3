class Article < ActiveRecord::Base
  include ThinkingSphinx::Scopes
  extend FriendlyId

  friendly_id :title, use: :slugged
  self.per_page = 4

  default_scope { order('updated_at DESC') }

  # Associations
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy
  has_attached_file :title_pic, styles: { medium: '', thumb: '' },
    default_url: '/assets/articles/:style/missing_titlepic.jpg',
    default_style: :medium,
    convert_options: {
      thumb:  '-gravity center -resize 390x250^ -crop 390x250+0+0',
      medium: '-gravity center -resize 806x400^ -crop 806x400+0+0'
    }
  acts_as_taggable

  # Validations
  validates :title, :description, presence: true
  validates :description, length: { minimum: 15, maximum: 130 }
  validates :title, length: { minimum: 15, maximum: 90 }
  validates :user_id, numericality: true
  validate :require_at_least_one_category

  # Callbacks
  after_save :reprocess_titlepic

  # Scopes
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }

  def send_article_confirmed_message
    ArticleMailer.article_confirmed_message(self).deliver
  end

  def send_article_rejected_message(reason)
    ArticleMailer.article_rejected_message(self, reason).deliver
  end

  def send_notification_to_subscribers
    checked_subscribers = [self.user]
    categories = self.categories.each do |category|
      subscribers = category.users - checked_subscribers
      checked_subscribers << subscribers
      ArticleMailer.new_article_message(self, category, subscribers).deliver
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

  def reprocess_titlepic
    if self.title_pic.present? && Pathname.new(self.title_pic.path).exist?
      self.title_pic.save
      dirname, _ = File.split(self.title_pic.path(:original))
      FileUtils.rm_rf(dirname)
    end
  end
end
