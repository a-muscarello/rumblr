
require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/User'
require_relative './models/Post'

# set :database, {adapter: 'postgresql', database: 'rubytumbler'}

enable :sessions

get '/' do
    erb :index
end

get '/home' do
    erb :index
end


get '/signup' do
    erb :signup
end

get '/login' do
    erb :login
end 

get '/about' do
    erb :about
end


get '/thankyou' do
    @user = User.find(session[:id])
    erb :thankyou
end

post '/user/login' do 
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        redirect '/profile'
    else   
        redirect '/signup'
    end 
end

post '/signup' do
    @newuser = User.create(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], password: params[:password])
    session[:id] = @newuser.id
    redirect '/thankyou'
end

get '/profile' do
    @user = User.find(session[:id])
    # @posts = Post.where(user_id: session[:id])
    erb :profile
end


get '/users' do
    @this_user = User.find(session[:id])
    # erb :edit
end

# renders edit user id
get '/edit' do
    @this_user = User.find(session[:id])
    erb :edit
end


put '/user/user_id' do
    @this_user = User.find(session[:id])
    x = params[:birthday]
    y = params[:email]
    z = params[:password]
    @this_user.update(birthday: x, email: y, password: z)
    redirect '/profile'
end
#WORKS  takes you to delete page
get '/delete' do
    erb :delete
end
#  WORKS deletes user
delete '/user/:id' do
    @this_user = User.find(params[:id])
    @this_user.destroy
    redirect '/user'
end
# renders post
get '/post' do
    @this_post = Post.where(user_id: session[:id])
    erb :post
end

get '/post/user_id' do
    @this_user = User.find(params[:id])
    erb :post
end

get '/new_post' do
    erb :new_post
end

post '/post/create/new' do
    @posts = Post.where(user_id: session[:id])
    @posts = Post.limit(20)
    Post.create(post_name: params[:post_name], post_content: params[:post_content], user_id:session[:id])
    redirect '/profile'
end

post '/post/submit' do
    Post.create(params[:user_id])
    redirect '/post'
end
#  starts to break here >>>>>
# allow to edit posts
put '/post/:id' do
    @post = Post.find(params[:id])
    @post.update(post_name: params[:post_name], post_content: params[:post_content], user_id: session[:id])
    redirect '/post'
end

# get '/post/user_id/edit' do
#     @posts = Post.find(params[:user_id])
#     @posts = Post.order("created_at DESC")
    # @posts = Post.order('created_at: :desc').limit(20)
    # @categories = Category.order(post: :desc)
#     erb :post
# end


#to edit the post
# put '/post/user_id/edit' do
    # @posts = Post.find(session[:id])
#     @this_user = User.find(session[:id])
#     a = params[:post_name]
#     b = params[:post_content]
#     @this_user.update(post_name: a, post_content: b)
#     redirect '/post'
# end

get '/logout' do
    erb :logout
end


get '/search' do
    erb :search
end

def self.search(search)
	where("name LIKE ?", "%#{search}%") 
	where("content LIKE ?", "%#{search}%")
end


private 

def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
end


