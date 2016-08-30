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

  def self.featured_posts
    featured.most_recent.
      where.not(id: latest.id).
      limit(6)
  end

  def self.other_posts(page)
    exclude_ids = featured_posts.pluck(:id)
    exclude_ids << latest.id

    published.most_recent.
      where.not(id: exclude_ids).
      paginate(page: page)
  end

  def rendered_content
    #this is an instance function that creates a md processor
    #shorter way to do it: markdown = Redcarpet::Markdown.new(Redcarpet::Render
    # ::HTML, autolink: true, tables: true)
    # markdown.render(content).html_safe
    #Basically it shows md converted into html to the user.
    renderer = Redcarpet::Render::HTML
    extensions = {
      autolink: true,
      tables: true,
      fenced_code_blocks: true
    }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(content).html_safe
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

end
