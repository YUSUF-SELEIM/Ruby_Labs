class ArticlesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  before_action :require_ownership!, only: [:edit, :update, :destroy]

  def index
    @articles = Article.public_article.order(created_at: :desc)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Current.user.articles.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted!"
  end

  def report
    if @article.user == Current.user
      redirect_to @article, alert: "You cannot report your own article!"
      return
    end

    @article.increment!(:reports_count)   
    @article.save                        

    redirect_to @article, notice: "Article reported!"
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def require_ownership!
    unless @article.user == Current.user
      redirect_to articles_path, alert: "you can only do that to your own articles"
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :image)
  end
end