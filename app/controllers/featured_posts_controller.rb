class FeaturedPostsController < ApplicationController
  def index
    @posts = Post.featured_posts
  end
