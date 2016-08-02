class AddImageToCategories < ActiveRecord::Migration[5.0]
  def change
    add_attachment :categories, :image
  end
end
