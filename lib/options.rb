# encoding: utf-8

#
#
# options
#
#
class Options
	attr_reader	:pre_generated_characters
	
  attr_reader :appearance_items_min
  attr_reader :features_items_min
  attr_reader :other_items_min
  
  attr_reader :appearance_items_max
  attr_reader :features_items_max
  attr_reader :other_items_max
		
	attr_reader :characters_count
	
	attr_reader :activities_min
	attr_reader :activities_max
	
	attr_reader :dresses_min
	attr_reader :dresses_max
	
	attr_reader :all_dresses_min
	attr_reader :all_dresses_max
	
	attr_reader :all_things_min
	attr_reader :all_things_max

  
  def self.create
    options = self.new
    
    options.ask
    
    return options
  end
  
  def self.create!
    # @options = self.create
    self.create_with_defaults!
  end
  
  
  def self.create_with_defaults!
    @options = self.new
  end
	
	
	def self.create_from_params! params
		@options = self.new
		
		@options.parse_params params
	end
  
  
  def self.get
    @options = self.create if @options.nil?
    
    return @options
  end
  
  
  def initialize
		@pre_generated_characters = false
		
    @appearance_items_min = 2
    @appearance_items_max = 5
    
    @features_items_min = 2
    @features_items_max = 5
    
    @other_items_min = 2
    @other_items_max = 5
		
		@characters_count = 6
		
		@activities_min = 2
		@activities_max = 5
		
		@dresses_min = 2
		@dresses_max = 5
		
		@all_dresses_min = 5
		@all_dresses_max = 10		
		
		@all_things_min = 5
		@all_things_max = 10				
		
  end
  
  
	# deprecated
  def ask
    ask_appearance_items_count
    ask_features_items_count
    ask_other_items_count
  end
  
  
  def ask_appearance_items_count
    read_int_from_keyboard(%(Минимальное количество характеристик внешности: ), @appearance_items_min) do |val| 
      @appearance_items_min = val
    end
    
    read_int_from_keyboard "Максимальное количество характеристик внешности: ", @appearance_items_max do |val|
      @appearance_items_max = val
    end
  end
  
  
  def ask_features_items_count
    read_int_from_keyboard "Минимальное количество характеристик характера: ", @features_items_min do |val|
      @features_items_min = val
    end
    
    read_int_from_keyboard "Максимальное количество характеристик характера: ", @features_items_max do |val|
      @features_items_max = val
    end
  end
  
  def ask_other_items_count
    read_int_from_keyboard "Минимальное количество других характеристик: ", @other_items_min do |val|
      @other_items_min = val
    end
    
    read_int_from_keyboard "Максимальное количество других характеристик: ", @other_items_max do |val|
      @other_items_max = val
    end      
  end
	
	
	
	#
	# extract options from params
	#
	def parse_params params
		[
			:appearance_items_min,
			:appearance_items_max,
			:features_items_min,
			:features_items_max,
			:other_items_max,
			:other_items_min,
			:characters_count,
			:activities_min,
			:activities_max,
			:dresses_min,
			:dresses_max,
			:all_dresses_min,
			:all_dresses_max,
			:all_things_min,
			:all_things_max			
		].each do |option|
			set_int_variable_from_params option, params
		end
		
		[
			:pre_generated_characters			
		].each do |option|
			set_boolean_variable_from_params option, params
		end
	end
	
  
	#
	#
	# private
	#
	#
  private
  
	#
	# ask options from keyboard
	#
  def read_int_from_keyboard (message, default_value, &block)
    STDERR.print message

    val = STDIN.readline
    block.call(default_value) unless val =~ /^[0-9]+/
    block.call(val.to_i)
  end
	
	
	#
	# int options setter from params
	#
	def set_int_variable_from_params key, params
		STDERR.puts "Options: trying to find #{key} in params"
		
		# return unless params.has_key?(key)
		# 
		return if params[key].nil?
		
		return if params[key] == ""
		
		STDERR.puts "Options: setting #{key} to #{params[key.to_sym]}"
		
		self.instance_variable_set "@#{key}", params[key.to_sym].to_i
	end
	
	
	#
	# boolean options setter from params
	#
	def set_boolean_variable_from_params key, params
		STDERR.puts "Options: trying to find #{key} in params"	
		
		value = false
		value = true if params[key]
		
		STDERR.puts "Options: setting #{key} to #{value}"		
		
		self.instance_variable_set "@#{key}", value	
	end
end
# End of Options class