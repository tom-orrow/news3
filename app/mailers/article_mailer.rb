class ArticleMailer < Devise::Mailer
  helper :application

  def article_confirmed_message(article)
    @article = article
    devise_mail(article.user, :article_confirmed)
  end

  def article_rejected_message(article, reason)
    @article = article
    @reason = reason
    devise_mail(article.user, :article_rejected)
  end
end
