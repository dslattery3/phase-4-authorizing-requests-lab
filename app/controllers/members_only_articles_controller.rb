class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    if session[:user_id]
      render json: articles, each_serializer: ArticleListSerializer
    else
      render json: {error: "Not authorized"}, status: 401
    end
  end

  def show
    article = Article.find(params[:id])
    if session[:user_id]
      render json: article
    else
      render json: {error: "Not authorized"}, status: 401
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
