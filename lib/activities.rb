require "unicode"


#
#
# Activity
#
#
class Activity
	EMOTIONS_REGEXP = /<emotions?.*>/i
	SPEECH_REGEXP = /<some +words?.*>/i
	SPACE_REGEXP = /<spaces?.*>/i	

	attr_reader :text
	
	def initialize text
		@text = text
	end
	
	
	def characters_count
		return Unicode::downcase(text).scan(/<subject *\d+>/).collect{ |i| i.scan(/\d+/)}.uniq.length
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
	
	
	
	def character_numbers
		return Unicode::downcase(text).scan(/<subject *\d+>/).collect{ |i| i.scan(/\d+/)}.uniq.collect{|i| i.first.to_i}.sort
	end
end

#
#
# activity in context
#
#
class ActivityInContext < OpenStruct
	def wrapped_text
		result = self.activity.text
		
		result = wrap_subjects(result)
		
		result = wrap_things(result)
		
		result = wrap_emotions(result)
		
		result = wrap_speechs(result)

		result = wrap_spaces(result)		
		
		return result
	end
	
	
	private
	
	
	def wrap_subjects a_text
		result = a_text.dup

		self.characters.each do |num, character|
			result.gsub!(/<subject *#{num}>/i, character.name)
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
		# things
		#
		result.things = @all_things.get 1, result.activity.things_count
		
		pp result
		
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