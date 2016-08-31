class Category < ApplicationRecord
  
  has_many :posts

  validates :name, :slug, :image, presence: true

  has_attached_file :image, styles: {
    hero: "2000x1277#",
    large:  "720x540#",
    medium: "500x500#",
    thumb: "200x200#"
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def published_count
    posts.published.count
  end

  def to_param
    slug
  end

end
