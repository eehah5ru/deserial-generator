require "unicode"
require_relative "utils.rb"
require_relative "options.rb"


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


class DressesCategorized < OpenStruct
	# attr_reader :top
	# attr_reader :bottom
	# attr_reader :shoes
	# attr_reader :accessories
	
	# def initialize
	# 	@top = RandomArray.new
	# 	@bottom = RandomArray.new
	# 	@shoes = RandomArray.new
	# 	@accessories = RandomArray.new
	# end
	
	def to_s
		return [
			self.top,
			self.bottom,
			self.shoes,
			self.accessories
		].join(". ")
	end
end

class DressesCategorizedBuilder
	
	def self.dresses_file= a_filename
		@dresses_file = a_filename
	end
	
	
	def self.builder
		return @builder unless @builder.nil?
		
		@builder = self.new(DataSource.new(@dresses_file))
		
		return @builder
	end
		
  #
  # Character builder class
  #
  
  def initialize (data_source)
    @data_source = data_source
  end
	
	
	def build
		result = DressesCategorized.new
		
		result.top = @data_source[:top].get 1
		result.bottom = @data_source[:bottom].get 1
		result.shoes = @data_source[:shoes].get 1
		result.accessories = @data_source[:accessories].get(Options.get.all_dresses_min, Options.get.all_dresses_max).join(". ")
		
		return result
	end
end