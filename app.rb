require 'sinatra'
require 'sinatra/activerecord'

# require_relative './models/user'
# require_relative './models/post'

set :database, {adapter: 'postgresql', database: 'rubytumbler'}


get '/user/new/create' do
    erb :new
end


get '/user/:id/edit' do
    @this_user = User.find(params[:id])
    erb :edit
end


put '/user/:id' do
    @this_user = User.find(params[:id])
    @this_usser.update(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], password: params[:password])
end


post '/post/new' do
    post.create(post_name: params[:post_name], post_content: params[:post_content], user_id: params[:user_id])
    redirect '/post'
end

post '/post/new' do
    post.create(post_name: params[:post_name], post_content: params[:post_content], user_id: params[:user_id])
    post.limit_to(post >= 20)
    redirect '/post'
end


#delete 
delete '/user/:id' do
    User.destryoy(params[:id])
    redirect '/user'
end