class CreatePostImages < ActiveRecord::Migration[5.0]
  def change
    create_table :post_images do |t|
      # we need to know which post the image is for
      t.integer :post_id, null: false
      # Special field that comes from paperclip
      t.attachment :image, null: false
      # t.timestamps is a method, null: false, which is a hash, is the value:
      # ({null: false}). This is why there's no comma here
      t.timestamps null: false
    end
  end
end
