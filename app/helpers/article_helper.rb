module ArticleHelper
  def nested_comments(comments)
    comments.map do |comment,_|
      content_tag(:div, render('articles/comment', comment: comment), class: 'nested_comments')
    end.join.html_safe
  end

  def split_and_wrap_article_title(title)
    title.scan(/.{1,30}(?: +|$\n?)/).map do |string|
      content_tag(:b, string) unless string.strip.nil?
    end.join.html_safe
  end

  def article_date_format(article, time = false)
    if time
      article.created_at.strftime("%b %e, %Y")
    else
      article.created_at.strftime("#{article.created_at.day.ordinalize} %B")
    end
  end
end
