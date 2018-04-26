
require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/user'
require_relative './models/post'

set :database, {adapter: 'postgresql', database: 'rubytumbler'}


get '/' do
    erb :index
end

get '/user' do
    @user = User.all
    erb :index
end

post '/user/login' do 
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        erb :profile
    else   
        #Could not find this user. Redirecting them to the signup page
        redirect '/signup'
    end 
end

get '/user/:id' do
    @this_user = User.find(params[:id])
    erb :login
end

get '/signup' do
    erb :'/signup'
end

get '/login' do
    erb :'/login'
end

get '/profile' do
    @user = User.find(session[:id])
    erb :profile
end

get '/someotherplace' do
    @user = User.find(session[:id])
    erb :randomplace
end

get '/logout' do
    #Clear all sessions  
    session.clear
    #You can also just set the session to nil like this : session[:id] = nil
    redirect '/login'
end




private 
#Potentially useful function instead of checking if the user exists
def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
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
    @this_post = Post.find(params[:user_id])
    erb :post
end

