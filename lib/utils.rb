require 'yaml'
require "unicode"
#
#
# random getter
#
#
class RandomArray < Array  
  
  #
  # get random a_count elements
  #
  def get a_count=1, max_count=nil
    unless max_count.nil?
      a_count = get_random_in_range(a_count, max_count)
    end
    
    if a_count > self.length
      return self.dup
    end
    
    indexes = []
    
    while indexes.length < a_count
      val = Random.rand self.length
      
      indexes << val unless indexes.include?(val)
    end
    
    return RandomArray.new(indexes.collect { |i| self[i]})
  end
  
  
  private
  
  
  def get_random_in_range min_value, max_value
    return Random.rand(min_value..(max_value+1))
  end
end


#
#
# Random access from plain text file
# separator in file is "\n"
#
#



class PlainFileRandomAccess < RandomArray
	def self.splitter= a_splitter
		# STDOUT.puts "!!!!!!!!\n!!!!!!!!\n!!!!!!!!!"
		@splitter = a_splitter
	end
	
	
	def self.splitter
		return "\n" if @splitter.nil?
		return @splitter
	end
	
	 
	def self.data_file= a_filename
		@data_file = a_filename
	end
	
	
	def self.data
		return @data unless @data.nil?
		
		# create
		@data = PlainFileRandomAccess.new
		
		File.read(@data_file).split(/#{splitter}/).each do |item|
			@data << item
		end
		
		return @data
	end
end



#
#
# YAML Data source
#
#
class DataSource
  def initialize (filename)
    @filename = filename
  end
  
  def [] a_key
    return RandomArray.new(data[a_key.to_s])
  end
  
  
  private
  
  
  def data
    @data = read_data if @data.nil?
    
    return @data
  end
  
  
  def read_data
    return YAML.load(File.open(@filename))
  end
end