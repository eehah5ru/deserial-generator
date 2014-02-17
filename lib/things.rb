require "unicode"


class Things < RandomArray
	def self.things_file= a_filename
		@things_file = a_filename
	end
	
	
	def self.things
		return @things unless @things.nil?
		
		# create
		@things = Things.new
		
		File.read(@things_file).split(/\n/).each do |item|
			@things << item
		end
		
		return @things
	end
end