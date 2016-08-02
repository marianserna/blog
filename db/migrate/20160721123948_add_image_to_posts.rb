class AddImageToPosts < ActiveRecord::Migration[5.0]
  def change
    # Before running migration, call this paperclip method and you tell it which table it will be attached to and the name of your attachment
    add_attachment :posts, :image
  end
end
