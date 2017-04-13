require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?

load './local_env.rb' if File.exists?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do 
	favorites=db.exec("SELECT first_name, last_name, fav_nums, fav_food, fav_phrase, age FROM favorites");
	erb :index, locals: {favorites: favorites}
end

post '/favorites' do
	id = params[:id]
	first_name = params[:first_name]
	last_name = params[:last_name]
	fav_nums = params[:fav_nums]
	fav_food = params[:fav_food]
	fav_phrase = params[:fav_phrase]
	age = params[:age]

db.exec("INSERT INTO favorites(first_name, last_name, fav_nums, fav_food, fav_phrase, age)
 		VALUES('#{first_name}', '#{last_name}' ,'#{fav_nums}', '#{fav_food}', '#{fav_phrase}', '#{age}')");
	redirect '/'
end

post '/update' do
    first_name_update = params[:first_name_update]
    first_name = params[:first_name]
    db.exec("UPDATE favorites SET first_name = '#{first_name_update}' WHERE first_name = '#{first_name}'");

   redirect '/'
end

post '/clear' do
	db.exec("DELETE FROM favorites");

	redirect '/'
end

# post 'delete' do
# 	id_delete = params[:id_delete]
# 	id = params[:id]
# 	db.exec("DELETE FROM phonebook WHERE id = '#{id}'");

# 	redirect '/'

# end