#encoding: utf-8
require "unicode"



module ActivityUtils
	def self.characters_count (a_text)
		return Unicode::downcase(a_text).scan(Activity::SUBJECT_REGEXP).collect{ |i| i.scan(/\d+/)}.uniq.length
	end
end
#
#
# Activity
#
#
class Activity
	SUBJECT_REGEXP = /<subject *\d+[^>]*>/i
	EMOTIONS_REGEXP = /<emotions?.*>/i
	SPEECH_REGEXP = /<some +words?.*>/i
	SPACE_REGEXP = /<spaces?.*>/i	
	CAMERA_MOVEMENT_REGEXP = /<camera.*>/i
	SOUND_REGEXP = /<sound.*>/i	

	attr_reader :text
	
	def initialize text
		@text = text
	end
	
	
	def characters_count
		return Unicode::downcase(text).scan(Activity.SUBJECT_REGEXP).collect{ |i| i.scan(/\d+/)}.uniq.length
	end
	
	
	def things_count
		return Unicode::downcase(text).scan(/<things? *>/).length
	end
	
	
	def emotions_count
		return Unicode::downcase(text).scan(EMOTIONS_REGEXP).length		
	end
	
	
	def speechs_count
		return Unicode::downcase(text).scan(SPEECH_REGEXP).length		
	end	
	
	
	def spaces_count
		return Unicode::downcase(text).scan(SPACE_REGEXP).length		
	end
	
	def camera_movements_count
		return Unicode::downcase(text).scan(CAMERA_MOVEMENT_REGEXP).length				
	end
	
	def sounds_count
		return Unicode::downcase(text).scan(SOUND_REGEXP).length				
	end	
	
	
	
	def character_numbers
		return Unicode::downcase(text).scan(SUBJECT_REGEXP).collect{ |i| i.scan(/\d+/)}.uniq.collect{|i| i.first.to_i}.sort
	end
end

#
#
# activity in context
#
#
class ActivityInContext < OpenStruct

	def wrapped_camera_direction
		result = self.camera_direction.dup
		
		result =  wrap_subjects(result)
		
		if ActivityUtils.characters_count(result) > 0
			result.gsub!(Activity::SUBJECT_REGEXP, '[нрзбр.]')
		end
		
		return result
	end
	
	def wrapped_camera_plan
		result = self.camera_plan.dup
		
		result = wrap_subjects(result)
		
		if ActivityUtils.characters_count(result) > 0
			result.gsub!(Activity::SUBJECT_REGEXP, '[нрзбр.]')
		end
		
		return result		
	end
	
	
	def wrapped_text
		result = self.activity.text
		
		
		result = wrap_camera_movements(result)
				
		result = wrap_subjects(result)
		
		result = wrap_things(result)
		
		result = wrap_emotions(result)
		
		result = wrap_speechs(result)

		result = wrap_spaces(result)		
		
		result = wrap_sounds(result)		
		
		return result
	end
	
	
	private
	
	
	def wrap_subjects a_text
		result = a_text.dup

		self.characters.each do |num, character|
			result.gsub!(/<subject *#{num}[^>]*>/i, character.name)
		end
		
		return result
	end
	
	
	def wrap_things a_text
		result = a_text.dup
		
		self.activity.things_count.times do 
			result.sub!(/<things? *>/i, self.things.get.first)
		end
		
		return result
	end
	
	
	def wrap_emotions a_text
		result = a_text.dup
		
		self.activity.emotions_count.times do 
			result.sub!(Activity::EMOTIONS_REGEXP, Emotions.data.get.first)
		end
		
		return result
	end
	
	
	def wrap_speechs a_text
		result = a_text.dup
		
		self.activity.speechs_count.times do 
			result.sub!(Activity::SPEECH_REGEXP, "\"#{Speechs.data.get.first}\"")
		end
		
		return result
	end
	
	
	def wrap_spaces a_text
		result = a_text.dup
		
		self.activity.spaces_count.times do 
			result.sub!(Activity::SPACE_REGEXP, Spaces.data.get.first)
		end
		
		return result
	end
	
	
	def wrap_camera_movements a_text
		result = a_text.dup
		
		self.activity.camera_movements_count.times do 
			result.sub!(Activity::CAMERA_MOVEMENT_REGEXP, CameraMovements.data.get.first)
		end
		
		return result
	end
	
	def wrap_sounds a_text
		result = a_text.dup
		
		self.activity.sounds_count.times do 
			result.sub!(Activity::SOUND_REGEXP, DiegeticSounds.data.get.first)
		end
		
		return result
	end	
end


#
#
# activity in context builder
#
#
class ActivityInContextBuilder
	def initialize screenplay
		@characters = screenplay.characters.dup
		# @all_dresses = screenplay.all_dresses.dup
		@all_things = screenplay.all_things.dup
	end
	
	def build activity
		result = ActivityInContext.new
		result.activity = activity.dup

		#
		# characters
		#
		result.characters = {}		
		activity.character_numbers.each do |character_number|
			result.characters[character_number] = @characters.get.first
		end
		
		#
		# dresses
		#
		# result.character_dresses = {}
		# result.characters.each do |num, character|
		# 	result.character_dresses[num] = @all_dresses.get(Options.get.dresses_min, Options.get.dresses_max)
		# end
		
		
		#
		# initial camera plan
		#
		result.camera_plan = CameraPlans.data.get.first		
		
		#
		# camera direction
		#
		result.camera_direction = CameraDirections.data.get.first
		
		#
		# duration in seconds
		#
		result.duration = Random.rand(5..15)
		
		
		#
		# lighting
		#
		result.lighting = Lightings.data.get.first
		
		#
		# space
		#
		result.space = Spaces.data.get.first
		
		#
		# things
		#
		result.things = @all_things.get 1, result.activity.things_count
		
		#
		# Non-diegetic sound
		#
		result.non_diegetic_sound = NonDiegeticSounds.data.get.first if Random.rand(0..100) > 70
		
		
		# pp result
		
		binding.pry
		
		return result
	end
	
	def build_many activities
		result = []
		
		activities.each do |activity|
			result << self.build(activity)
		end
		
		return result
	end
end


#
#
# singleton contains all activities from all files
#
#
class Activities < RandomArray
	def self.directory= dir_name
		@dir_name = dir_name
	end
	
	
	# singleton getter
	def self.activities
		return @activities unless @activities.nil?
		
		
		# create activities
		@activities = Activities.new
		
		Dir.glob(File.join(@dir_name, "*.txt")).each do |file_name|
			load_activities_from_file (file_name)
		end
		
		return @activities
	end
	
	
	private
	
	
	def self.load_activities_from_file file_name
		File.read(file_name).split(/\n\n/).each do |activity_text|
			@activities << Activity.new(activity_text)
		end
	end
	
end