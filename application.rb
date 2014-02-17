require 'sinatra'
require 'slim'
require 'yaml'
require_relative "lib/options.rb"
require_relative "lib/characters_generator.rb"
require_relative "lib/screenplay_generator.rb"
require_relative "lib/activities.rb"
require_relative "lib/dresses.rb"



#
#
# Генератор героев
#
get '/characters' do
  slim :characters_form
end


post '/characters' do
	Options.create_from_params! params
	
	@characters = generate_characters params
  
  slim :characters
end


#
#
# Генератор сценария
#
#
get '/screenplay' do
	slim :screenplay_form
end


post '/screenplay' do
	@screenplay = generate_screenplay params
		
	slim :screenplay
end


def generate_characters params
  # CharacterBuilder::Options.create!

  builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))
  
  characters = []
  
  params[:characters_count].to_i.times do |i|
    characters << builder.build
  end
	
	return characters
end


def generate_screenplay params
	Options.create_from_params! params
	Activities.directory = "data/activities"
	Dresses.dresses_file = "data/dresses.txt"
	
	# Activities.activities.get
	
  characters_builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))	
	
	screenplay_builder = ScreenplayBuilder.new characters_builder
	
	return screenplay_builder.build
end



