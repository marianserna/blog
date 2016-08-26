class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @suggested_posts = @post.category.posts.where.not(id: @post.id).published.
      most_recent.limit(3)
  end
end
