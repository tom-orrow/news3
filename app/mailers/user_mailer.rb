class UserMailer < Devise::Mailer
  helper :application

  def welcome_message(record, opts={})
    devise_mail(record, :welcome_message, opts)
  end
end
