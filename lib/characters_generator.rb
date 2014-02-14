#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'ostruct'
require 'pp'

class Character < OpenStruct
  def to_s
    return [
			self.name,
      self.sex,
      self.age,
			self.heigh,
			self.body,
			self.hairs,
			self.hair_lebgth,
      self.appearance,
      self.features,
      self.other
    ].compact.join(" ")
  end
	
	def about
    return [
      self.sex,
      self.age,
			self.heigh,
			self.body,
			self.hairs,
			self.hair_lebgth,
      self.appearance,
      self.features,
      self.other
    ].compact.join(" ")
	end
end


class RandomGetterToArray
  def initialize (data)
    @data = data
    
    # raise RuntimeError, "Data should be an array" unless data.is_a?
  end
  
  
  #
  # get random a_count elements
  #
  def get a_count=1, max_count=nil
    unless max_count.nil?
      a_count = get_random_in_range(a_count, max_count)
    end
    
    if a_count > @data.length
      return @data.dup
    end
    
    indexes = []
    
    while indexes.length < a_count
      val = Random.rand @data.length
      
      indexes << val unless indexes.include?(val)
    end
    
    return indexes.collect { |i| @data[i]}
  end
  
  
  private
  
  
  def get_random_in_range min_value, max_value
    return Random.rand(min_value..(max_value+1))
  end
end

class DataSource
  def initialize (filename)
    @filename = filename
  end
  
  def [] a_key
    return RandomGetterToArray.new(data[a_key.to_s])
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

class CharacterBuilder
  class Options
    attr_reader :appearance_items_min
    attr_reader :features_items_min
    attr_reader :other_items_min
    
    attr_reader :appearance_items_max
    attr_reader :features_items_max
    attr_reader :other_items_max
    
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
    
    
    def self.get
      @options = self.create if @options.nil?
      
      return @options
    end
    
    
    def initialize
      @appearance_items_min = 2
      @appearance_items_max = 5
      
      @features_items_min = 2
      @features_items_max = 5
      
      @other_items_min = 2
      @other_items_max = 5
    end
    
    
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
    
    
    private
    
    def read_int_from_keyboard (message, default_value, &block)
      STDERR.print message

      val = STDIN.readline
      block.call(default_value) unless val =~ /^[0-9]+/
      block.call(val.to_i)
    end
  end
  # End of Options class

  
  #
  # Character builder class
  #
  
  def initialize (data_source)
    @data_source = data_source
  end
  
  
  def build
    character = Character.new
    
		# set naem
		character.name = @data_source[:name].get
		
    # set sex
    character.sex = @data_source[:sex].get
    
    # set age
    character.age = @data_source[:age].get
		
		# heigh
    character.heigh = @data_source[:heigh].get
		
		# body
		character.body = @data_source[:body].get
		
		# hairs
		character.hairs = @data_source[:hairs].get
		
		# hair_length
		character.hair_length = @data_source[:hair_length].get
		
    # set appearance
    character.appearance = @data_source[:appearance].get Options.get.appearance_items_min, Options.get.appearance_items_max
    
    # set features
    character.features = @data_source[:features].get Options.get.features_items_min, Options.get.features_items_max
    
    return character
  end  
end


#
# sex
# age
# heigh
# appereance
# features
# other

#
# main routine
#

# raise RuntimeError, "You should specify data file as argument" if ARGV.length < 1


# 10.times do
#   STDOUT.puts builder.build
#   STDOUT.puts "\n\n"
# end





