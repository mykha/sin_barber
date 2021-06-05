require 'sinatra'
bears can't bear beards, but our bears can bearbears can't bear beards, but our bears can bear#require 'sinatra/reloader'

configure do
  enable :sessions
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
	erb "<div class=\"jumbotron text-center\"> <p>a bear with a bears can't bear beards, but our bears can bear</p></div><h1></h1>"
	#erb :forshave
end

post '/' do

	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@title = "Thank you !"
	@message = "Dear #{@user_name}, we are waiting for you #{@date_time}"

	input = File.open "./clients.txt", "a"
	input.puts "client=#{@user_name};phone=#{@phone};date_time=#{@date_time}"	
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
