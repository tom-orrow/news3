class ArticlesController < ApplicationController
  before_filter :get_categories
  load_and_authorize_resource except: [:index, :show, :search], through: :current_user

  def index
    @articles = Article.by_category(@current_category).active.paginate(page: params[:page])
  end

  def search
    @articles = Article.search(
      params[:q],
      page: params[:page],
      per_page: Article.per_page,
      field_weight: { title: 20 },
      with: { active: true }
    )
    render :index
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.roots
    @comment = @article.comments.build(parent_id: params[:parent_id])
    render :index if @article.nil?
  end

  def new
    @article = Article.new
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

  private

  def get_categories
    @categories ||= Category.all
    @current_category = params['category_id'] ? params['category_id'].to_i : nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end

  def article_params
    params.require(:article).permit(
      :title, :user_id, :description, :body, :tag_list, :title_pic, category_ids: []
    )
  end
end
