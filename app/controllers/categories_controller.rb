class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name).all
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @posts = @category.posts.published.most_recent.paginate(page: params[:page])
  end
end
