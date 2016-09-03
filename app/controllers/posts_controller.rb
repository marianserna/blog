class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @posts = Post.other_posts(params[:page])
      end
      format.json do
        @posts = Post.published.most_recent.first(3)
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    @suggested_posts = @post.category.posts.where.not(id: @post.id).published.
      most_recent.limit(3)
  end
end
