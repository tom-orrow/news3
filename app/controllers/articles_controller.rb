class ArticlesController < ApplicationController
  before_filter :get_categories

  def index
    @articles = Article.active
    if @current_category
      @articles = @articles.where( category_id: @current_category )
    end
  end

  def show
    @article = Article.where( id: params['id'] ).first
    render :index if @article.nil?
  end

  def new
  end

  private

  def get_categories
    @categories = Category.all
    @current_category = params['category_id'].to_i if params['category_id'] else nil
  end

end
