class UserMailer < Devise::Mailer
  helper :application

  def welcome_message(record, opts = {})
    devise_mail(record, :welcome_message, opts)
  end

  def article_confirmed_message(record, opts = {})
    devise_mail(record, :article_confirmed, opts)
  end

  def article_rejected_message(record, opts = {})
    devise_mail(record, :article_rejected, opts)
  end
end
