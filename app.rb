
require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/User'
require_relative './models/Post'

# set :database, {adapter: 'postgresql', database: 'rubytumbler'}

configure do
    enable :sessions
    set :sessions_secret, "wrenrrtgehjsdfjgksgkkg"
end

get '/' do
    if User.exists?(:id => session[:id])
        @user = User.find(session[:id])
        erb :index
    end
    erb :index
end

get '/home' do
    erb :index
end


get '/signup' do
    erb :index
end

get '/user/login' do
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
    @user = User.create(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], password: params[:password])
    session[:id] = @user.id
    redirect '/thankyou'
end

get '/profile' do
    @user = User.find(session[:id])
    @posts = Post.where(user_id: session[:id]).limit(20)
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
    session.clear
    redirect '/user'
end
# renders post

get '/post/user_id' do
    @this_user = User.find(params[:id])
    erb :post
end

get '/new_post' do
    erb :new_post
end

post '/post/create/new' do
    @posts = Post.where(user_id: session[:id])
    
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

get '/profile/:anything/edit' do
        @post = Post.find(params[:anything])
        erb :edit_post
end    

#to edit the post
put '/profile/:post_id/edit' do
    @post = Post.find(params[:post_id])
    @post.update(post_name: params[:post_name], post_content: params[:post_content], user_id: session[:id])
    redirect '/profile'
end

delete '/profile/:post_id/delete' do
    @post = Post.find(params[:post_id])
    @post.destroy
    redirect '/profile'
end

get '/logout' do
    session.clear
     redirect '/'
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


