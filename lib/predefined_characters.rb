require "ostruct"

class PredefinedCharacter < OpenStruct
  def to_s
    return [
			self.name,
			self.description
    ].compact.join(" ")
  end
	
	def about
		return "" if self.description.nil?
		
		return [self.description].join(" ")
	end
end


class PredefinedCharacters
	
	def self.characters_file= a_filename
		@characters_file = a_filename
	end
	
	
	def self.get *args
		return get_builder.get(args)
	end
	
	
	def self.get_all
		return get_builder.get_all
	end
  #
  # Character builder class
  #
  
  def initialize (characters_file)
		@characters = create_characters(characters_file)
  end
	
	
	def get *args
		return @characters.get(args)
	end
	
	def get_all
		return @characters.dup
	end		
	
	private
	
	
	def self.get_builder
		return @builder unless @builder.nil?
		
		@builder = self.new(@characters_file)
		
		return @builder
	end
	
	
	def create_characters (a_file)
		result = RandomArray.new
		
		YAML.load(File.open(a_file)).each do |raw_character|
			result << PredefinedCharacter.new(:name => raw_character["name"], :description => raw_character["description"])
		end
		
		return result
	end
end