require 'dm-core'
require 'dm-migrations'

# define a class to represent table
class Student
  # include ERB::Util
  # attr_accessor :title
  include DataMapper::Resource
  property :id, Serial    #auto increment primary key
  property :name, String
  property :comment, Text
  property :year, Integer
  property :birthday, Date

  def birthday=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

configure do
  enable :sessions
  set :username, 'karsten'
  set :password, '54321'
end

DataMapper.finalize
# DataMapper.auto_migrate!
# called after loading all models, before the app accessing table

get'/styles.css'do
  scss :styles
end

get '/students' do
  @student = Student.all #return all the students created in an array
  erb :students
end

get '/comment' do
  @student = Student.all
  erb :comment
end

#protect routes
get '/students/new' do
  puts "~~~~~~~~~~~~~~~~~~~~~~~~session is: "
  #{session[:admin]}"
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.new
  erb :new_student
end


#
get '/students/:id' do
  @student = Student.get(params[:id])
  # puts '@@@@@'
  # puts @student.name
  # puts '@@@@@'
  erb :show_student
end

get '/students/:id/edit' do
  @student = Student.get(params[:id])
  erb :edit_student
end

post '/students' do
  #student = Student.create(params[:student])
  student = Student.create()
  # puts '~~~~~'
  #puts params[:student][:name]
  #puts params[:student][:birthday]

  student.name = params[:student][:name]
  student.birthday = params[:student][:birthday]
  student.year = params[:student][:year]
  student.comment = params[:student][:comment]

  student.save
  #student.name = params[:student][:name]
  #student.name = params[:student][:name]

  redirect to("/students/#{student.id}")
end


put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end




#check login info and see if they are correct
post '/login' do
    if params[:username] == settings.username && params[:password]==settings.password
      session[:admin]=true
      redirect to('/students')
    else
      erb :login
    end
end
