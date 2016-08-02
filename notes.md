```
gem update rails
rails new blog --database=postgresql
rails db:create
```

Initialize git repository
```
git init
git add .
git commit -am "blabla"
```
Go to github --> new repository
create new repository
Copy the push lines from github:

…or push an existing repository from the command line

git remote add origin git@github.com:marianserna/blog.git
git push -u origin master

```
rails g migration CreateCategories
```

In db > migrate, create some categories (name, slug, timestamps)

```ruby
class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
  end
end
```

```
rails db:migrate
```

models > new file: category.rb (singular)
Inside, create a model which is just a class

```ruby
class Category < ApplicationRecord
  has_many :posts

  validates :name, :slug, presence: true
end
```

```
rails g migration CreatePosts
```

Go to db > migrate > CreatePosts
```ruby
class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :category_id, null: false
      t.string :title, null: false
      t.text :summary, null: false
      t.text :content, null: false
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end
```

```
rails db:migrate
```

Each table has a matching model. Let's create the model:
app > models > post.rb

```ruby
class Post < ApplicationRecord
  belongs_to :category

  validates :title, :summary, :content, :published, presence: true
end
```


-------------------

Now we'll create some pages: Go to config > routes

```ruby
Rails.application.routes.draw do

  namespace :admin do
    resources :categories
  end

end
```

```
rails routes
```

Go to controllers and create a new folder called admin
Inside it, create a file called categories_controller.rb

```ruby
class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
end
```

Go to views and create an admin folder
Create a folder called categories inside the admin folder

Install the haml gem in the gemfile
```
bundle install
```

Create a file called index.html.haml in views > admin > categories

```ruby
= link_to('New Category', new_admin_category_url, class: 'button')

%table
  %thead
    %tr
      %th Name
      %th Action
  %tbody
    - @categories.each do |category|
      %tr
        %td= category.name
        %td= link_to('Edit', edit_admin_category_url(category))
```


2 -----------------

We'll add the action for the "New Category" in the categories_controller

```ruby
class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end
end
```

Now we need the view. In views > admin > categories, create new.html.haml

Use the simple_form gem

```
gem 'simple_form', '~> 3.2', '>= 3.2.1'
bundle install
```

run this command so that simple_form runs well with foundation
```
rails g simple_form:install --foundation
```

In new.html.haml, create a form to introduce a new category

```ruby
%h2 New Category

= simple_form_for @category, url: [:admin, @category] do |f|
  =f.input :name
  =f.input :slug
  =f.submit
  = link_to('Cancel', admin_categories_url, class: 'button')
  ```

Now we need the "create" action

```ruby
def create
  @category = Category.new(category_params)
  if @category.save
    flash[:success] = 'Your category has been created!'
    redirect_to admin_categories_url
  else
    render :new
  end
end


private

def category_params
  # We require the params to have a category and we permit it to have a name and a slug
  params.require(:category).permit(:name, :slug)
end
```


Let's add the edit action in the controller

```ruby
def edit
  @category = Category.find(params[:id])
end
```

Now we need an edit view

```ruby
%h2 Editing #{@category.name}

= render partial: 'form'
```

Because the form is the same for new and edit, we created a partial in views > admin > categories, called `_form.html.haml`


Now, create the update action

```ruby
def update
  @category = Category.find(params[:id])
  if @category.update(category_params)
    flash[:success] = 'Your category has been updated!'
    redirect_to admin_categories_url
  else
    render :edit
  end
end
```


For the flash message to show up in the view, go to views > layouts > application.html.erb
Switch it to haml by renaming it and change the erb code inside to haml

```ruby
!!!
%html
  %head
    %title Blog
    = csrf_meta_tags
    = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_include_tag 'application', 'data-turbolinks-track': 'reload'

%body
  /This is for your flash message to show up
  - flash.each do |key, value|
    .callout= value

  = yield
```

Install the foundation_rails gem in the gemfile,
`bundle install`

then run `rails g foundation:install`

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
When you forget something in your migration:
`rails g migration AddSlugToBoards`

Then go to the migration:

```ruby
class AddSlugToBoards < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :slug, :string, null: false
  end
end
```

`rails db:migrate`

Finally, fix your model:
```ruby
class Board < ApplicationRecord
  has_many :pins

  validates :name, :slug, presence: true
end
```
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


3 ------------------------------------------------------------------------------
Now we'll be working on the POSTS
Add a set of routes for posts in config > routes

```ruby
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :categories
    resources :posts
  end
end
```


Create the controller

class Admin::PostsController < ApplicationController

  def index
    @posts = Post.all
  end
end


Create the view

```ruby
= link_to('New Post', new_admin_post_url, class: 'button')

%table
  %thead
    %tr
      %th Name
      %th Category
      %th Image
      %th Action
  %tbody
    - @posts.each do |post|
      %tr
        %td= post.title
        %td= post.category.name
        -# This is to show your image (See paperclip doc). If you don't put :thumb, you'll see the original image
        %td= image_tag(post.image.url(:thumb))
        %td= link_to('Edit', edit_admin_post_url(post))
```

For being able to upload images, add the paperclip gem
`bundle install`

`rails g migration AddImageToPosts`

Go to the paperclip documentation where it says "Quick Start", then Go to the migration

```ruby
class AddImageToPosts < ActiveRecord::Migration[5.0]
  def change
    # Before running migration, call this paperclip method and you tell it which table it will be attached to and the name of your attachment
    add_attachment :posts, :image
  end
end
```

`rails db:migrate`

Now we have to tell the post model that it will have an attachment.
Copy the 2 model lines form the paperclip doc, put them below the validates line.

Modify them according to your needs:

Original:
```
has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
```

Modified:
```
has_attached_file :image, styles: { wide_1440: "1440x460#", thumb: "200x200>" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
```

Add image to your validation

```ruby
class Post < ApplicationRecord
  belongs_to :category

  validates :title, :summary, :content, :published, :image, presence: true
  has_attached_file :image, styles: { wide_1440: "1440x460#", thumb: "200x200>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
```

Create the new action

```ruby
def new
  @post = Post.new
end
```

Create the view

```ruby
%h2 New Post

=simple_form_for(@post, url: [:admin, @post]) do |f|
  -# pluck gives you and array of arrays, which is the format that simple_form expects
  = f.input :category_id, collection: Category.pluck(:name, :id)
  =f.input :image, as: :file
  =f.input :title
  =f.input :summary
  =f.input :content
  =f.submit
```


4 ------------------------------------------------------------------------------


Let's create the create action

```ruby
def create
  @post = Post.new(post_params)
  if @post.save
    flash[:success] = 'There is a New Post!'
    redirect_to admin_posts_url
  else
    render :new
  end
end


private

def post_params
  params.require(:post).permit(
    :title, :summary, :image, :content, :category_id
  )
end
```


Create the Edit Action

```ruby
def edit
  # the find method always takes the id
  @post = Post.find(params[:id])
end
```

Now we need the edit form so we'll create a partial for the form and call it

```ruby
=simple_form_for(@post, url: [:admin, @post]) do |f|
  -# pluck gives you and array of arrays, which is the format that simple_form expects
  = f.input :category_id, collection: Category.pluck(:name, :id)
  = f.input :published
  - if @post.image.present?
    = image_tag @post.image.url(:thumb)
  =f.input :image, as: :file
  =f.input :title
  =f.input :summary
  =f.input :content
  =f.submit
  = link_to('Cancel', admin_posts_url, class: 'button')
```

`= render partial: 'form'`

Create the update action

```ruby
def update
  @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = 'The post has been updated!'
      redirect_to admin_posts_url
    else
      render :edit
    end
  ```


Now, we're going to add pagination

Install the will_paginate gem
re-start ur rails s after u install a gem

1) Go to your posts controller and change your index action

```ruby
def index
  @posts = Post.paginate(page: params[:page])
end
```

2) Go to the index view and add this line outside the form:

`= will_paginate @posts`


Repeat those steps for categories

```ruby
def index
  @categories = Category.paginate(page: params[:page])
end
```

and, in the view

`= will_paginate @categories`


________________________________________________________________________________

WE'LL CREATE AN UGLY HOME PAGE NOW

this is the flow: route, then controller, then the views for those actions,
and any models as you need them.

Go to config > routes

Outside the admin, add this code:

<!-- Tell it which controller and action will handle the home page: controller home, action show -->
```
root to: 'home#show'
```

Now, we'll create the controller outside the admin folder as well, using the
action we said we'll use (show):

home_controller.rb

```ruby
class HomeController < ApplicationController
  def show
    # Fnd the last 18 posts to show them
    posts = Post.last(18)
    #Create this variable to be used in your view
    @first_post = posts.first
  end
end
```

To create the home view, create a new folder in views outside of admin, call it home,
inside it, create a file called show.html.haml

```ruby
.latest
  %h2= @first_post.title
  %p= @first_post.category.name
  = image_tag @first_post.image.url(:wide_1440)
  ```


5 ------------------------------------------------------------------------------

Go to .gitignore and write this at the very bottom

<!-- Ignore locally uploaded images: We don't want to commit these to github -->
`/public/system/*`

Go to the home controller and update the code so that the view only shows the
first 18 posts that have been published, starting from the last one

```ruby
class HomeController < ApplicationController
  def show
    # Fnd the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    posts = Post.where(published: true).order(created_at: :desc).first(18)
    @first_post = posts.first
  end
end
```

Because we'll be using some of this code in other areas, we'll create a scope
in the post model

```ruby
scope :published, -> { where(published: true) }
scope :most_recent, -> { order(created_at: :desc) }
```

Now, the code in the controller will look like this:

```ruby
class HomeController < ApplicationController
  def show
    # Fnd the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    @first_post = Post.published.most_recent.first
  end
end
```

`rails g migration AddFeaturedToPosts`

Go to the migration

```ruby
class AddFeaturedToPosts < ActiveRecord::Migration[5.0]
  def change
    # Add a new column including -> table name, column name, type of column, and options.
    add_column :posts, :featured, :boolean, null: false, default: false
  end
end
```

`rails db:migrate`

Go to admin > posts_controller and add featured to the post_params

```ruby
def post_params
  params.require(:post).permit(
    :title, :summary, :image, :content, :category_id,
    :published, :featured
  )
end
```

Do the same in the admin > posts form

```ruby
=simple_form_for(@post, url: [:admin, @post]) do |f|
  -# pluck gives you and array of arrays, which is the format that simple_form expects
  = f.input :category_id, collection: Category.pluck(:name, :id)
  = f.input :published
  = f.input :featured

  - if @post.image.present?
    = image_tag @post.image.url(:thumb)

  =f.input :image, as: :file
  =f.input :title
  =f.input :summary
  =f.input :content
  =f.submit
  = link_to('Cancel', admin_posts_url, class: 'button')
```


Go to the post model and add a new scope for featured:

scope :published, -> { where(published: true) }
`scope :featured, -> { published.where(featured: true) }`
scope :most_recent, -> { order(created_at: :desc) }

Now, in home_controller, re-factor your code and add a featured_posts variable:

```ruby
class HomeController < ApplicationController
  def show
    # Fnd the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    @first_post = Post.published.most_recent.first
    @featured_posts = Post.featured.most_recent.first(5)
  end
end
```

To avoid errors, go to show.html.haml and add an if statement:

```ruby
- if @first_post
  .latest
    %h2= @first_post.title
    %p= @first_post.category.name
    = image_tag @first_post.image.url(:wide_1440)
```

Modify the show.html.haml to include the featured posts

```ruby
- if @first_post
  -# Add multiple classes in haml
  .post.latest
    %h2= @first_post.title
    %p= @first_post.category.name
    %p= @first_post.summary
    = image_tag @first_post.image.url(:wide_1440)

- @featured_posts.each do |post|
  .post.featured
    %h2= post.title
    %p= post.category.name
    %p= post.summary
    = image_tag post.image.url(:thumb)
```


In the home controller, add a statement to avoid repeating the first post
in the view:

```ruby
class HomeController < ApplicationController
  def show
    # Find the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    @first_post = Post.published.most_recent.first
    @featured_posts = Post.featured.most_recent.
      # Find featured posts where the id is not the same as the first post
      # to avoid having this post twice
      where.not(id: @first_post.id).
      first(5)
  end
end
```


In the post.rb model, introduce new sizes for the pictures:

```ruby
has_attached_file :image, styles: {
  # In paperclip, the pound means to crop the image to fit in the scpace we are
  # indicating
  hero: "2000x1277#",
  large:  "720x540#",
  medium: "500x500#",
  thumb: "200x200#"
}
```

Run
`bundle exec rake paperclip:refresh CLASS=Post`

It will generate images for the styles you have defined in your models
(produces them from an original file -- a pic you upload).


Now, let's organize the view to use the sizes we've created

```ruby
- if @first_post
  -# Add multiple classes in haml
  .post.latest
    %h2= @first_post.title
    %p= @first_post.category.name
    %p= @first_post.summary
    = image_tag @first_post.image.url(:hero)

-# each_with_index loops thru featured_posts and tells us in which posts it is.
  # What I wanna say is:
  # if 1 or 2 ... bigger else normal size featured
  # each with index looks thru all posts but it gives us a 2nd variable : index
  # If you get an error, try using the var index after post |post, index|
- @featured_posts.each_with_index do |post, index|
  -# Create a size variable and set it to a ternary
  -# operator (just an if statement): If index >= 2, then (?) use medium,
  -# else (:), use large.
  - size = index >= 2 ? :medium : :large
  .post.featured{class: size}
    %h2= post.title
    %p= post.category.name
    %p= post.summary
    = image_tag post.image.url(size)
```


Now, we will organize the home_controller to find non-featured posts to be
displayed in the home page:

```ruby
class HomeController < ApplicationController
  def show
    # Find the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    @first_post = Post.published.most_recent.first
    # this is an array of posts
    # Find featured posts where the id is not the same as the first post
    # to avoid having this post twice
    @featured_posts = Post.featured.most_recent.
      where.not(id: @first_post.id).
      first(5)

    # map converts an array into another array
    # posts = Post.all -- You have an array with everything
    # posts.map(&:title) -- This gets you an array with one property
    # with more than one property: -- format depends on whether u want array
    # of array or array of hashes. A of H is way easier to understand
    # if there's a lot of info. This is an array of hashes:
    posts= Post.all
    posts.map do |post|
      {
        title: post.title,
        summary: post.summary
      }
    end

    # Create a variable called exclude_ids to contain an array of ids that won't
    # be included in the query below: we do not want any of the posts we have
    # already found (they would be repeated)

    # To push stuff into an array - the ruby way - do this:
    # array << whatever you wanna push:  ids << 100 (ids.push(100))

    exclude_ids = @featured_posts.map(&:id)
    exclude_ids << @first_post.id

    @posts = Post.published.most_recent.
      where.not(id: exclude_ids).
      first(9)
  end
end
```

Now we'll go to the view to show the posts:

Let's add a breaker to show the categories:

```ruby
.categories
  View Categories
```
And, this is how we'll show the posts

```ruby
- @posts.each do |post|
  .post.medium
    %h2= post.title
    %p= post.category.name
    %p= post.summary
    = image_tag post.image.url(:medium)
```


We're going to create the show page for a post:

Go to routes
Write this code outside the namespace but before it

```
resources :posts, only: [:show]
```

`rails routes`

We're going to create links for the posts in the view:

```ruby
- if @first_post
  -# Add multiple classes in haml
  .post.latest
    %h2= @first_post.title
    %p= @first_post.category.name
    %p= @first_post.summary
    = image_tag @first_post.image.url(:hero)
    = link_to 'Read Post', post_url(@first_post)

-# each_with_index loops thru featured_posts and tells us in which posts it is.
  # What I wanna say is:
  # if 1 or 2 ... bigger else normal size featured
  # each with index looks thru all posts but it gives us a 2nd variable : index
  # If you get an error, try using the var index after post |post, index|
- @featured_posts.each_with_index do |post, index|
  -# Create a size variable and set it to a ternary
  -# operator (just an if statement): If index >= 2, then (?) use medium,
  -# else (:), use large.
  - size = index >= 2 ? :medium : :large
  .post.featured{class: size}
    %h2= post.title
    %p= post.category.name
    %p= post.summary
    = image_tag post.image.url(size)
    = link_to 'Read Post', post_url(post)

.categories
  View Categories

- @posts.each do |post|
  .post.medium
    %h2= post.title
    %p= post.category.name
    %p= post.summary
    = image_tag post.image.url(:medium)
    = link_to 'Read Post', post_url(post)
```


Create a posts_controller.rb with a show action

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end
```


Now, create a folder in view called posts and inside a show.html.haml

```ruby
%h2= @post.title
%p= @post.category.name
= image_tag @post.image.url(:hero)

= @post.content
```

Let's get the view categories working.

We need to create a new page for the view categories

Go to routes:

`resources :categories, only: [:index, :show]`

Go back to the view and modify the code snippet where we introduced the
categories breaker:

```ruby
.categories
  -# categories_url is a helper that comes from the routes
  = link_to 'View Categories', categories_url
```

Now create a categories_controller:

```ruby
class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name).all
  end

  def show
    @category = Category.find(params[:id])
  end
end
```

Now create a view folder for categories and an index.html.haml:

```ruby
- @categories.each do |category|
  = link_to category.name, category_url(category)
```


Now we need to work on the show view: Create a show.html.haml file in the
categories folder in the view

```ruby
%h2= @category.name
```

Go to the categories index (index.html.haml)

Change the code to:

```ruby
%ul
  - @categories.each do |category|
    %li= link_to category.name, category_url(category)
```

This will allow us to see the categories better.


`rails g migration AddImageToCategories`

Go to the migration

```ruby
class AddImageToCategories < ActiveRecord::Migration[5.0]
  def change
    add_attachment :categories, :image
  end
end
```

rails db:migrate

Go to the category model

```ruby
class Category < ApplicationRecord
  has_many :posts

  validates :name, :slug, :image, presence: true

  has_attached_file :image, styles: {
    # In paperclip, the pound means to crop the image to fit in the scpace we are
    # indicating
    hero: "2000x1277#",
    large:  "720x540#",
    medium: "500x500#",
    thumb: "200x200#"
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
```

Go to views > admin > category > form

We're gonna add a field to be able to upload an image for your categories

```ruby
-# Use simple_form_for to build a form
= simple_form_for @category, url: [:admin, @category] do |f|
  =f.input :name
  =f.input :slug

  - if @category.image.present?
    = image_tag @category.image.url(:thumb)

  =f.input :image, as: :file

  =f.submit
  = link_to('Cancel', admin_categories_url, class: 'button')
  ```


In the categories controller, update the categories_params method to allow images:

```ruby

  private

  def category_params
    # We require the params to have a category and we permit it to have a name and a slug
    params.require(:category).permit(:name, :slug, :image)
  end
end
```


Go to views > admin > categories > index.html.haml and add an image to the table

```ruby
= link_to('New Category', new_admin_category_url, class: 'button')

%table
  %thead
    %tr
      %th Name
     `%th Image`
      %th Action
  %tbody
    - @categories.each do |category|
      %tr
        %td= category.name
        `%td= image_tag category.image.url(:thumb)`
        %td= link_to('Edit', edit_admin_category_url(category))

= will_paginate @categories
```
In the categories model, create a published_count method:

```ruby
def published_count
  posts.published.count
end
```

Go to views > categories > index.html.haml and add an image tag. Aditionally,
display how many posts are there in a category.
We're gonna use the pluralize method (for the "Posts" word)

```ruby
%ul
  - @categories.each do |category|
    %li
      = link_to category.name, category_url(category)
      = image_tag category.image.url(:medium)
      -# Display how many posts are there in this category
      -# Let's use the pluralize method to help us say post or posts depending
      -# on the number of publications in a category. You give it the number
      -# (category.published_count), then the word and it figures out whether to
      -# use singular or plural
      %p= pluralize(category.published_count, 'Post')
      # (If were embeded ruby, it would be %p= "#{category.published_count} Posts")
```


In the categories controller, create an @posts variable

```ruby
def show
  @category = Category.find(params[:id])
  @posts = @category.posts.published.most_recent.paginate(page: params[:page])
end
```

In views > categories > show.html.haml, create an image tag and ...

```ruby
%h2= @category.name

= image_tag @category.image.url(:hero)

- @posts.each do |post|
  = render partial: 'posts/medium_unit', locals: {post: post}
  # locals: {post: post} -- locals are variables that we are passing from
  # show.html.haml where we are rendering the partial (it is not the partial
  # itself but the thing that calls it, the file we are in) // there are 2 views
  # in here: show and the view brought with the partial. The partial view doesn't
  # have access to the variables in the show.html.haml so, that's what locals does.
  # it brings the variable we tell it to, depending on which one we need to show
  # according to what we are doing in the partial, in this case, we need the variable
  # post. {post :post} The first one is what we want it to be called (the key),
  # the value is the thing itself (the thing we're passing)

= will_paginate @posts
  ```

We're gonna use the medium post size in several places, so, let's get the content
from home > show.html.haml and create  a partial called medium_unit.html.haml
inside views > posts

```ruby
.post.medium
  %h2= post.title
  %p= post.category.name
  %p= post.summary
  = image_tag post.image.url(:medium)
  = link_to 'Read Post', post_url(post)
```

Cut that from home > show.html.haml and replace it with
`= render partial: 'posts/medium_unit', locals: {post: post}`


Now we are going to add suggested posts to the bottom of the show page.

In the posts controller, create a suggested posts variable

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    `@suggested_posts = @post.category.posts.where.not(id: @post.id).published.
      most_recent.limit(3)`
    end
  end
end
```

Go to the posts view and loop thru the suggested posts

```ruby
%h2= @post.title
%p= @post.category.name
= image_tag @post.image.url(:hero)

= @post.content
`- @suggested_posts.each do |post|
  = render partial: 'posts/medium_unit', locals: {post: post}`
```

Get the `redcarpet` gem, which converts markdown to html

`gem 'redcarpet', '~> 3.3', '>= 3.3.4'`

bundle install

Go to the documentation for the gem and check how to install the gem. Copy the
link : `markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
  autolink: true, tables: true)`

In the post model create a new method after the scopes:

```ruby
def rendered_content
  #this creates a md processor
  #shorter way to do it: markdown = Redcarpet::Markdown.new(Redcarpet::Render
  # ::HTML, autolink: true, tables: true)
  # markdown.render(content).html_safe
  renderer = Redcarpet::Render::HTML
  extensions = {
    autolink: true,
    tables: true
  }
  markdown = Redcarpet::Markdown.new(renderer, extensions)
  markdown.render(content).html_safe
end
```

Go to posts > show.html.haml and change a line of code:

```ruby
%h2= @post.title
%p= @post.category.name
= image_tag @post.image.url(:hero)

`= @post.rendered_content` #this line

- @suggested_posts.each do |post|
  = render partial: 'posts/medium_unit', locals: {post: post}
```


Get the devise gem

`gem 'devise', '~> 4.2'`

`bundle install
rails generate devise:install --- gives you some steps for the installation

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views
`

In config > environments > development, put this line of code:

`config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`

Run `rails g devise:views` --> this is erb
Run `rails generate devise MODEL` (MODEL IN THIS CASE WOULD BE USER)

Devise creates a model, migration, views, and tests for you.

In the user.rb model, keep only `:database_authenticatable` and
delete the others.

Go to the migration and comment out or delete the ones we aren't using.

`rails db:migrate`

Delete `<%= render "devise/shared/links" %>` from views > sessions > new.html.haml
(This one should be kept in pintastic)

Now, let's create a user from the command line:
`User.create!(email: 'marianhalliday@gmail.com', password: 'your password')`

In pintastic, to add a name field, you'll have to add it in the devise migration,
also in the sign up form and so on.
