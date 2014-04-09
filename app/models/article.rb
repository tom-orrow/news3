class Article < ActiveRecord::Base
  include ThinkingSphinx::Scopes

  self.per_page = 4

  default_scope { order('updated_at DESC') }

  # Associations
  belongs_to :user
  has_and_belongs_to_many :category
  has_many :comments, dependent: :destroy
  has_attached_file :title_pic, styles: { original: '', thumb: '' },
    default_url: '/assets/articles/:style/missing_titlepic.jpg',
    convert_options: {
      thumb:  '-gravity center -resize 390x250^ -crop 390x250+0+0 -blur 0x2',
      original: '-gravity center -resize 806x400^ -crop 806x400+0+0'
    }
  acts_as_taggable

  # Validations
  validates :title, :description, presence: true
  validates :user_id, numericality: true
  validate :require_at_least_one_category

  # Scopes
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }

  def to_param
    "#{id} #{title}".parameterize
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
    errors.add :base, 'Article requires at least one category selected.' if category.blank?
  end
end
