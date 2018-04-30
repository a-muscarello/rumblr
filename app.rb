
require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/user'
require_relative './models/post'

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
    @posts = Post.where(user_id: session[:id])
    erb :profile
end


put '/user/:id' do
    @this_user = User.find(params[:id])
    @this_user.update(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], password: params[:password])
end

get '/users' do
    @this_user = User.find(session[:id])
    # erb :edit
end

get '/edit' do
    @this_user = User.find(session[:id])
    erb :edit
end

put '/user/:id/edit' do
    @this_user = User.find(session[:id])
    erb :edit
end

# get '/edit' do
#     User.find(session[:id])
#     redirect '/users'
# end

get '/delete' do
    erb :delete
end

delete '/user/:id' do
    User.destroy(params[:id])
    redirect '/user'
end


post '/post/create/new' do
    @posts = Post.limit(20)
    Post.create(post_name: params[:post_name], post_content: params[:post_content], user_id:session[:id])
    redirect '/profile'
end

get '/new_post' do
    erb :new_post
end

post '/post/submit' do
    Post.create(params[:user_id])
    redirect '/post'
end

get '/post/:user_id' do
    @posts = Post.find(params[:user_id])
    @posts = Post.order("created_at DESC")
    # @posts = Post.order('created_at: :desc').limit(20)
    @categories = Category.order(post: :desc)
    erb :post
end


#to edit the post
get '/post/:user_id' do
    @posts = Post.find(params[:user_id])
    erb :post
end

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


