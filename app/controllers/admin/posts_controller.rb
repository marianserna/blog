class Admin::PostsController < ApplicationController

  def index
    @posts = Post.paginate(page: params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save!
      flash[:success] = 'There is a New Post!'
      redirect_to admin_posts_url
    else
      render :new
    end
  end

  def edit
    # the find method always takes the id
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
      if @post.update(post_params)
        flash[:success] = 'The post has been updated!'
        redirect_to admin_posts_url
      else
        render :edit
      end
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :summary, :image, :content, :category_id,
      :published, :featured
    )
  end
end
