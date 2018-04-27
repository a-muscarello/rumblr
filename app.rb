
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


get '/profile' do
    @user = User.find(session[:id])
    @posts = Post.where(user_id: session[:id])
    erb :profile
end


get '/logout' do
    #Clear all sessions  
    session.clear
    #You can also just set the session to nil like this : session[:id] = nil
    redirect '/login'
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


get '/post/create/new_post' do
    Post.create(post_name: params[:post_name], post_content: params[:post_content])
    session[:id] = @newuser.id
    redirect '/post'
end

#to edit the post
get '/post/:user_id/post' do
    @posts = Post.find(params[:user_id])
    erb :post
end

