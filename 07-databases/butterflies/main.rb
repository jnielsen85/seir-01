require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pry'

get '/' do
  erb :home
end

# INDEX -- Show all the butterflies: READ
get '/butterflies' do
  @butterflies = query_db 'SELECT * FROM butterflies'
  erb :butterflies_index
end

# NEW -- Shows the form to create a butterfly
get '/butterflies/new' do
  erb :butterflies_new
end

# CREATE -- Add a new butterfly to the database
post '/butterflies' do
  query = "INSERT INTO butterflies (name, family, image) VALUES ('#{ params[:name] }', '#{ params[:family] }', '#{ params[:image] }')"
  query_db query
  redirect to('/butterflies') # GET
end

# SHOW -- Shows a single butterfly: READ
get '/butterflies/:id' do
  @butterfly = query_db "SELECT * FROM butterflies WHERE id=#{ params[:id] }" # Returns an array
  @butterfly = @butterfly.first # Extract the butterfly from the array
  erb :butterflies_show
end

# EDIT -- Shows the form to edit a single butterfly: READ
get '/butterflies/:id/edit' do
  @butterfly = query_db "SELECT * FROM butterflies WHERE id=#{ params[:id] }" # Returns an array
  @butterfly = @butterfly.first # Extract the butterfly from the array
  erb :butterflies_edit
end

# UPDATE -- Update the database with new information for an existing butterfly
post '/butterflies/:id' do
  query = "UPDATE butterflies SET name='#{ params[:name] }', family='#{ params[:family] }', image='#{ params[:image] }' WHERE id=#{ params[:id] }"
  query_db query
  redirect to("/butterflies/#{ params[:id] }") # GET
end

# DELETE -- Delete a single butterfly from the database
get '/butterflies/:id/delete' do
  query_db "DELETE FROM butterflies WHERE id=#{ params[:id] }"
  redirect to('/butterflies')
end

def query_db(sql_statement)
  puts sql_statement # Optional but it's nice for debugging
  db = SQLite3::Database.new 'database.sqlite3'
  db.results_as_hash = true
  results = db.execute sql_statement
  db.close
  results # implicit returned
end
