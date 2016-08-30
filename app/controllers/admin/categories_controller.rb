class Admin::CategoriesController < Admin::BaseController
  before_action :load_category, only: [:edit, :update]

  def index
    @categories = Category.paginate(page: params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Your category has been created!'
      redirect_to admin_categories_url
    else
      render :new
    end
  end

  def edit
    #load_category called before_action
  end

  def update
    #load_category called before_action
    if @category.update(category_params)
      flash[:success] = 'Your category has been updated!'
      redirect_to admin_categories_url
    else
      render :edit
    end
  end


  private

  def category_params
    # We require the params to have a category and we permit it to have a name and a slug
    params.require(:category).permit(:name, :slug, :image)
  end

  def load_category
    @category = Category.find_by(slug: params[:id])
  end
end
