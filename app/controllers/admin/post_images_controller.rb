class Admin::PostImagesController < Admin::BaseController
  #before doing anything, call the method find_post, which sets the @post variable.
  before_action :find_post

  def new
    # If we do PostImage.new, it will create a new image. However, it
    #   won't identify to which post the image belongs
    @post_image = @post.post_images.new
  end

  def create
    # We create a new image and give it the post_image_params (method below)
    @post_image = @post.post_images.new(post_image_params)
    # Try to save the image (! is used only if you want to see what's wrong)
    if @post_image.save
      flash[:success] = "Image has been saved!"
      redirect_to edit_admin_post_url(@post)
    else
      flash[:error] = "Oops! Something went wrong..."
      render :new
    end
  end

  def destroy
    @post_image = @post.post_images.find(params[:id])
    @post_image.destroy
    flash[:success] = "Image has been deleted."
    redirect_to edit_admin_post_url(@post)
  end

  private

  def post_image_params
    params.require(:post_image).permit(:image)
  end

  def find_post
    # First we find the post the image will belong to.
    # Since this is nested, you need to go to post first
    # params[:post_id] is used to access the post id, because :id corresponds to
    # the id of one of the images of that post. The routes will show you this structure:
    # /admin/posts/:post_id/post_images/:id(.:format)
    @post = Post.find(params[:post_id])
  end

end
