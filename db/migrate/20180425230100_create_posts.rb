class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :post_name
      t.text :post_content
      t.string :user_id
    end
  end
end
