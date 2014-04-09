class ArticlesController < ApplicationController
  include ActionView::Helpers::TextHelper
  load_and_authorize_resource only: [:new, :create, :destroy]

  def index
    @articles = Article.by_category(@current_category).active.paginate(page: params[:page])
    @page_title = @current_category ? 'Category: ' << @categories_list.find(@current_category).name : 'New Articles'
    @unsubscribed = current_user.categories.exists?(@current_category).nil? if @current_category
  end

  def search
    @articles = Article.search(params)
    @page_title = "Search Results: #{pluralize(@articles.total, 'Article', 'Articles')} Found"
    render :index
  rescue Tire::Search::SearchRequestFailed
    redirect_to root_url, alert: "Sorry, your query '#{params[:q]}' is invalid."
  end

  def subscribe
    authorize! :update, current_user
    category = @categories_list.find(@current_category)
    current_user.categories << category
    redirect_to category_path(category), notice: "You have been successfully subscribed for new #{category.name} articles."
  end

  def unsubscribe
    authorize! :update, current_user
    category = @categories_list.find(@current_category)
    current_user.categories.delete(category)
    redirect_to category_path(category), notice: "You have been successfully unsubscribed from new #{category.name} articles."
  end

  def show
    @article = Article.friendly.find(params[:id])
    @comments = @article.comments.roots
    @comment = @article.comments.build(parent_id: params[:parent_id])
    render :index if @article.nil?
  end

  def new
    @article = Article.new
  end

  def preview
    params[:article][:user_id] = current_user.id
    @article = Article.new(article_params)
    render partial: 'edit', article: @article
  end

  def create
    params[:article][:user_id] = current_user.id
    @article = Article.new(article_params)
    if @article.save
      redirect_to root_path, notice: 'Article successfully created and is waiting for moderation.'
    else
      render :new
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    render json: { success: true }
  end

  private

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end

  def article_params
    params.require(:article).permit(
      :title, :user_id, :description, :body, :tag_list, :title_pic, :active, category_ids: [],
    )
  end
end
