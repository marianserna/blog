class PostImage < ApplicationRecord
  belongs_to :post

  has_attached_file :image, styles: {
    # In paperclip, the pound means to crop the image to fit in the scpace we are
    # indicating

    large:  "1500x1500",
    medium: "1000x1000",
    small: "500x500",
    # means cropping, which is why we removed them from hero, large, and medium
    thumb: "200x200#"
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :image, presence: true
end
