#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'ostruct'
require 'pp'

require_relative "utils.rb"
require_relative "options.rb"

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
      self.other,
			self.all_dresses.join(". ")
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
      self.other,
			self.all_dresses.join(". ")
    ].compact.join(" ")
	end
end

class CharacterBuilder
  #
  # Character builder class
  #
  
  def initialize (data_source)
    @data_source = data_source
  end
  
  
  def build
    character = Character.new
    
		# set naem
		character.name = @data_source[:name].get.first
		
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
		character.features = RandomArray.new
    character.features = @data_source[:features].get(Options.get.features_items_min, Options.get.features_items_max) unless Options.get.features_items_max == 0
		
		# dresses
		character.all_dresses = RandomArray.new
		character.all_dresses = RandomArray.new(Dresses.dresses.get(Options.get.all_dresses_min, Options.get.all_dresses_max)) unless Options.get.all_dresses_max == 0
    
    return character
  end  
	
	
	def build_many a_count
		result = []
		
		a_count.times do 
			result << self.build
		end
		
		return result
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





