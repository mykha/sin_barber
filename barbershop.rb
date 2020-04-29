require 'sinatra'

get '/' do
	erb :index
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