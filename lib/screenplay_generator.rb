require "ostruct"
# require_relative "generator.rb"


#
#
# screenplay
#
#
class Screenplay < OpenStruct
	def initialize
		super
		@characters = RandomArray.new []
	end
	
	
	def has? key
		return self.send(key) != nil
	end
end

#
#
# Screenplay Builder
#
#
class ScreenplayBuilder
	#
	# constructor
	#
	def initialize characters_builder
		@characters_builder = characters_builder
	end
	
	
	def build
		screenplay = Screenplay.new
		
		# characters
		screenplay.characters = RandomArray.new(@characters_builder.build_many(Options.get.characters_count))
		
		# # dresses
		# screenplay.all_dresses = RandomArray.new(Dresses.dresses.get(Options.get.all_dresses_min, Options.get.all_dresses_max))
		
		# things
		screenplay.all_things = Things.things.get(Options.get.all_things_min, Options.get.all_things_max)
		
		activity_in_context_builder = ActivityInContextBuilder.new(screenplay)
		
		screenplay.activities = activity_in_context_builder.build_many(Activities.activities.get(Options.get.activities_min, Options.get.activities_max))
		
		return screenplay
	end
end