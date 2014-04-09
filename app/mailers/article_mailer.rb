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

  def new_article_message(article, category, subscriber)
    @article = article
    @category = category
    devise_mail(subscriber, :new_article)
  end
end
