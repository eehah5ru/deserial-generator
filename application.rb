require 'sinatra'
require 'slim'
require 'yaml'
require_relative "lib/options.rb"
require_relative "lib/characters_generator.rb"
require_relative "lib/screenplay_generator.rb"
require_relative "lib/activities.rb"
require_relative "lib/dresses.rb"
require_relative "lib/things.rb"
require_relative "lib/emotions.rb"
require_relative "lib/speechs.rb"
require_relative "lib/spaces.rb"
require_relative "lib/predefined_characters.rb"



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

	Dresses.dresses_file = "data/dresses.txt"
	DressesCategorizedBuilder.dresses_file = "data/dresses_categorized.yml"	
	
  builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))
  
  characters = []
  
  params[:characters_count].to_i.times do |i|
    characters << builder.build
  end
	
	return characters
end


def generate_screenplay params
	#
	# creaete options
	#
	Options.create_from_params! params
	
	Activities.directory = "data/activities"
	Dresses.dresses_file = "data/dresses.txt"
	DressesCategorizedBuilder.dresses_file = "data/dresses_categorized.yml"
	Things.things_file = "data/things.txt"
	Emotions.data_file = "data/emotions.txt"	
	Speechs.data_file = "data/speechs.txt"	
	Spaces.data_file = "data/spaces.txt"			
	PredefinedCharacters.characters_file = "data/predefined_characters.yml"
	
	# Activities.activities.get
	
  characters_builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))	
	
	screenplay_builder = ScreenplayBuilder.new characters_builder
	
	return screenplay_builder.build
end



