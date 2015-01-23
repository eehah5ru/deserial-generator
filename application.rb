require 'sinatra'
require 'slim'
require 'yaml'
require 'securerandom'

require 'pry'
require 'ap'

require_relative "lib/options.rb"
require_relative "lib/characters_generator.rb"
require_relative "lib/screenplay_generator.rb"
require_relative "lib/activities.rb"
require_relative "lib/dresses.rb"
require_relative "lib/things.rb"
require_relative "lib/emotions.rb"
require_relative "lib/camera_plans.rb"
require_relative "lib/camera_movements.rb"
require_relative "lib/camera_directions.rb"
require_relative "lib/speechs.rb"
require_relative "lib/spaces.rb"
require_relative "lib/diegetic_sounds.rb"
require_relative "lib/non_diegetic_sounds.rb"
require_relative "lib/lightings.rb"
require_relative "lib/genres.rb"
require_relative "lib/predefined_characters.rb"

require_relative "lib/presentation.rb"



Pry.pager = false
Pry.quiet = true

# command_set = Pry::CommandSet.new do
#   command "greet" do |name|
#     output.puts "hello #{name}"
#   end
# end

Pry.hooks.delete_hooks(:before_session)

Pry::Hooks.new.add_hook(:before_session, :default) do |out, target, _pry_|
  # next if _pry_.quiet?
  # _pry_.run_command("whereami --quiet")
end


Pry.config.hooks.add_hook(:when_started, :print_screenplay) do |out, target, _pry_|
	_pry_.current_binding.eval("Presentation.show_screenplay result if defined?(result) and result.is_a?(Screenplay)")
	sleep 1
end

Pry.config.hooks.add_hook(:when_started, :print_character) do |out, target, _pry_|
	_pry_.current_binding.eval("Presentation.show_character character if defined?(character) and character.is_a?(Character)")
	sleep 1
end

Pry.config.hooks.add_hook(:when_started, :print_activity) do |out, target, _pry_|
	_pry_.current_binding.eval("Presentation.show_activity result if defined?(result) and result.is_a?(ActivityInContext)")
	sleep 1
end

Pry.config.hooks.add_hook(:when_started, :print_whereami) do |out, target, _pry_|
	next if rand * 100 < 50
	
	num_lines = (rand * 20).to_i

  _pry_.run_command("whereami #{num_lines}")
end


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
  # binding.pry
	# Pry.start binding, :commands => command_set
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
	CameraMovements.data_file = "data/camera_movements.txt"		
	CameraPlans.data_file = "data/camera_plans.txt"		
	CameraDirections.data_file = "data/camera_directions.txt"			
	Speechs.data_file = "data/speechs.txt"	
	Spaces.data_file = "data/spaces.txt"			
	DiegeticSounds.data_file = "data/diegetic_sounds.txt"	
	NonDiegeticSounds.data_file = "data/non_diegetic_sounds.txt"		
	Lightings.data_file = "data/lightings.txt"	
	Genres.data_file = "data/genres.txt"						
	PredefinedCharacters.characters_file = "data/predefined_characters.yml"
	
	# pp Spaces.data
	
	# Activities.activities.get
	
  characters_builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))	
	
	screenplay_builder = ScreenplayBuilder.new characters_builder
	
	result = screenplay_builder.build

	binding.pry

	return result
end


