require "unicode"


class Dresses < RandomArray
	def self.dresses_file= a_filename
		@dresses_file = a_filename
	end
	
	
	def self.dresses
		return @dresses unless @dresses.nil?
		
		# create
		@dresses = Dresses.new
		
		File.read(@dresses_file).split(/\n/).each do |dress_item|
			@dresses << Unicode::capitalize(dress_item)
		end
		
		return @dresses
	end
end