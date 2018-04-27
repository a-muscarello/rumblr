
require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/user'
require_relative './models/post'

set :database, {adapter: 'postgresql', database: 'rubytumbler'}

enable :sessions

get '/' do
    erb :index
end

get '/signup' do
    erb :signup
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
        #Could not find this user. Redirecting them to the signup page
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

get '/user/:id/edit' do
    @this_user = User.find(params[:id])
    erb :edit
end

#delete user id
delete '/user/:id' do
    User.destryoy(params[:id])
    redirect '/user'
end


post '/post/create/new' do
    Post.create(post_name: params[:post_name], post_content: params[:post_content])
    session[:id] = @newuser.id
    redirect '/post'
end

#to edit the post
get '/post/:user_id' do
    @posts = Post.find(params[:user_id])
    erb :post
end

private 

def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
end


