class User < ActiveRecord::Base

  ROLES = %w(admin moderator)

  # Associations
  has_many :services, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_and_belongs_to_many :categories

  # Validations
  validates :role, inclusion: ['admin', 'moderator', '']
  validates :fullname, length: { minimum: 3, maximum: 20 }

  # Devise. Other options: :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  def role?(base_role)
    return false unless role.present?
    ROLES.index(base_role.to_s) >= ROLES.index(role)
  end

  # Create user authorized through OmniAuth
  def self.create_user_from_omniauth(auth)
    user = User.new(
      fullname: auth.extra.raw_info.name,
      email: auth.info.email,
      password: Devise.friendly_token[0,10]
    )
    user.skip_confirmation!
    user.save!
    user.send_welcome_message if user.valid?
    user
  end

  def confirm!
    send_welcome_message
    super
  end

  def send_welcome_message
    UserMailer.welcome_message(self).deliver
  end
end
