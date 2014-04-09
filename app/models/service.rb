class Service < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, :provider, :uid, presence: true

  def self.create_service(auth, user_id)
    Service.create!(
      user_id: user_id,
      provider: auth.provider,
      uid: auth.uid,
      uname: auth.extra.raw_info.name,
    )
  end

  def self.find_user_by_email_duplication(auth)
    user = User.where(email: auth.info.email).first
    self.create_service(auth, user.id) if user
    user
  end

  def self.find_for_oauth(auth)
    service = Service.where(provider: auth.provider, uid: auth.uid).first
    if service
      user = service.user
    else
      user = self.find_user_by_email_duplication(auth)
      unless user

        transaction do
          user = User.create_user_from_omniauth(auth)
          self.create_service(auth, user.id)
        end
      end
    end
    user
  end
end
