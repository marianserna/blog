class Post < ApplicationRecord
  belongs_to :category
  has_many :post_images

  validates :title, :summary, :content, :image, presence: true
  has_attached_file :image, styles: {
    # In paperclip, the pound means to crop the image to fit in the scpace we are
    # indicating
    hero: "2000x1277#",
    large:  "720x540#",
    medium: "500x500#",
    thumb: "200x200#"
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :published, -> { where(published: true) }
  scope :featured, -> { published.where(featured: true) }
  scope :most_recent, -> { order(created_at: :desc) }

  def self.latest
    published.most_recent.first
  end

  def rendered_content
    Kramdown::Document.new(content, input: 'GFM').to_html.html_safe
  end

  # To_param is a function that returns something and parameterize places a dash in between words
  # This is called by the url rails helpers and placed into the url
  def to_param
    "#{id}-#{title}".parameterize
  end

end
