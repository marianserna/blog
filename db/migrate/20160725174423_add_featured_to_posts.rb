class AddFeaturedToPosts < ActiveRecord::Migration[5.0]
  def change
    # Add a new column including -> table name, column name, type of column, and options.
    add_column :posts, :featured, :boolean, null: false, default: false
  end
end
