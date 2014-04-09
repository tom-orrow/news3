class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :vkontakte, :twitter]

  attr_accessible :email, :password, :password_confirmation, :fullname
  has_many :services

  def self.create_user(auth)
    user = User.new(
      fullname: auth.extra.raw_info.name,
      email: auth.info.email,
      password: Devise.friendly_token[0,10]
    )
    user.skip_confirmation!
    user.save!
    user.send_welcome_message unless user.invalid?
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
