require 'sinatra'
#require 'sinatra/reloader'
require './secure.rb'


=begin
class User
	include DataMapper::Resource
	property :id, Serial
	property :username, String, :required => true, key: true, unique_index: true
	property :userpass, String, :required => true
	property :supervisor, Boolean, :default => false
#	property :password, String, length: 10..255
end

class Barber
	include DataMapper::Resource
	property :id, Serial
	property :barbername, String, :required => true, key: true, unique_index: true
	property :username, String, :required => true, key: true, unique_index: true
#	property :password, String, length: 10..255
end


class Order
	include DataMapper::Resource
	property :id, Serial
	property :client_name, Text, :required => true
	property :client_phone, Text, :required => true
	property :order_date,  DateTime, :required => true
	has n, :services
	belongs_to :barber
end

class Service
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
	has n, :tasks
end

DataMapper.finalize.auto_upgrade!
>>>>>>> bcd6be1158d4cdfb0a7cd878489682003ea44cf6
=end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

get '/' do
	erb :index
end

get '/signupforashave' do
	#erb "<h1>sign up for a shave</h1>"
	erb :forshave
end

get '/about' do
	erb "<div class=\"jumbotron text-center\"> <p>a bear can not bear beards, but our bears can bear</p></div><h1></h1>"
	#erb :forshave
end

get '/signupforashave' do
	erb "<h1>sign up for a shave</h1>"
	#erb :forshave
end

post '/' do

	@user_name = params[:inputName]
	@phone = params[:inputPhone]
	@date_time = params[:inputDate]
	@service = params[:inputService]
	@barber = params[:inputBarber]
	@title = "Thank you !"
	@message = "Dear #{@user_name}, we are waiting for you #{@date_time}"

	input = File.open "./clients.txt", "a"
	input.puts "client=#{@user_name};phone=#{@phone};date_time=#{@date_time}; service=#{@service};barber=#{@barber};"	
	input.close
	erb :message

end

get '/admin' do

	output = File.open "./clients.txt", "r"
	#"client=#{@user_name};phone=#{@phone};date_time=#{@date_time}"	
	#data_string = output.gets 
	@data = []
	
	while (line = output.gets)
#		@data << line.chomp
		@data_hash = {}
		line.split(';') do |str_column|
			arr_sub = str_column.split('=') 
			@data_hash[arr_sub[0].to_sym] = arr_sub[1] 
		end
		@data << @data_hash
	end 

	output.close

	erb :support

end
