class HomeController < ApplicationController
  def show
    # Find the last 18 posts to show them
    # Use timestamps to order your posted posts from the most recent one
    @post = Post.latest
    # this is an array of posts
    # Find featured posts where the id is not the same as the first post
    # to avoid having this post twice
  #   @featured_posts = Post.featured.most_recent.
  #     where.not(id: @first_post.id).
  #     first(5)
  #
  #   # map converts an array into another array
  #   # posts = Post.all -- You have an array with everything
  #   # posts.map(&:title) -- This gets you an array with one property
  #   # with more than one property: -- format depends on whether u want array
  #   # of array or array of hashes. A of H is way easier to understand
  #   # if there's a lot of info. This is an array of hashes:
  #   # posts= Post.all
  #   # posts.map do |post|
  #   #   {
  #   #     title: post.title,
  #   #     summary: post.summary
  #   #   }
  #   # end
  #
  #   # Create a variable called exclude_ids to contain an array of ids that won't
  #   # be included in the query below: we do not want any of the posts we have
  #   # already found (they would be repeated)
  #
  #   # To push stuff into an array - the ruby way - do this:
  #   # array << whatever you wanna push:  ids << 100 (ids.push(100))
  #
  #   exclude_ids = @featured_posts.map(&:id)
  #   exclude_ids << @first_post.id
  #
  #   @posts = Post.published.most_recent.
  #     where.not(id: exclude_ids).
  #     first(9)
  end
end
