require "unicode"


#
#
# Activity
#
#
class Activity
	attr_reader :text
	
	def initialize text
		@text = text
	end
	
	
	def characters_count
		return Unicode::downcase(text).scan(/<subject *\d+>/).collect{ |i| i.scan(/\d+/)}.uniq.length
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
end


#
#
# activity in context builder
#
#
class ActivityInContextBuilder
	def initialize characters, all_dresses
		@characters = characters.dup
		@all_dresses = all_dresses.dup
	end
	
	def build activity
		result = ActivityInContext.new
		result.activity = activity.dup
		result.characters = {}
		
		activity.character_numbers.each do |character_number|
			result.characters[character_number] = @characters.get.first
		end
		
		#
		# dresses
		#
		result.character_dresses = {}
		result.characters.each do |num, character|
			result.character_dresses[num] = @all_dresses.get(Options.get.dresses_min, Options.get.dresses_max)
		end
		
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