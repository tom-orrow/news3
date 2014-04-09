class Service < ActiveRecord::Base
  attr_accessible :provider, :uid, :uname, :user_id
  validates :user_id, :provider, :uid, presence: true
  belongs_to :user

  def self.create_service(auth, user_id)
    Service.create(
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
    service = Service.where(:provider => auth.provider, :uid => auth.uid).first

    unless service
      user = self.find_user_by_email_duplication(auth)
      unless user
        transaction do
          user = User.create_user(auth)
          self.create_service(auth, user.id)
        end
      end
    else
      user = service.user
    end
    user
  end

end
