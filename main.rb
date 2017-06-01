require 'sinatra'
require 'erb'
require './student'

configure do
  enable :sessions
  set :username, 'karsten'
  set :password, '54321'
end

# set up data base
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/studentlist.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get'/styles.css'do
  scss :styles
end

get '/' do
  erb :home
end

get '/about' do
  @title = "Website About Page"
  erb :about
end

get '/contact' do
  erb :contact
end

get '/video' do
  erb :video
end

#login and logout slim
get'/login'do
  erb :login
end

get '/logout' do
  session.clear
  session
  redirect to ('/login')
end


not_found do
  erb :not_found
end
