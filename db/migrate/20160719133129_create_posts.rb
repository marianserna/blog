class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :category_id, null: false
      t.string :title, null: false
      t.text :summary, null: false
      t.text :content, null: false
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end
