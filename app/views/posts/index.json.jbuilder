json.array! @posts do |post|
  json.(post, :id, :title, :summary)
  json.url post_url(post)
  json.category post.category.name
  json.image_url asset_url(post.image.url(:medium))
end
