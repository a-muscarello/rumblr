class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :post_name
      t.text :post_content
      t.integer :user_id
    end
  end
end


ost Controller

def index
  @posts = Post.all
  if params[:search]
    @posts = Post.search(params[:search]).order("created_at DESC")
  else
    @posts = Post.all.order('created_at DESC')
  end
end
