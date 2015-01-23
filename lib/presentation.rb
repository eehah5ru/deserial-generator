
require 'ap'


#
# scripts
#

# while true; do sleep 5; sh script.sh ; done

# while true; do ruby -e "if rand * 100 < 40 then puts 'exit' else puts 'step'; puts 'whereami' end"; done | rackup config.ru

class Presentation
	AP_OPTIONS = {
	  :indent => -2,
		:plain      => false,  # Use colors.
	  :color => {
			:args       => :pale,
			:array      => :white,
			:bigdecimal => :blue,
			:class      => :yellow,
			:date       => :greenish,
			:falseclass => :red,
			:fixnum     => :blue,
			:float      => :blue,
			:hash       => :pale,
			:keyword    => :cyan,
			:method     => :purpleish,
			:nilclass   => :red,
			:rational   => :blue,
			:string     => :yellowish,
			:struct     => :pale,
			:symbol     => :cyanish,
			:time       => :greenish,
			:trueclass  => :green,
			:variable   => :cyanish
  }
}

	def self.show_screenplay r
		# r.characters.map do |c|
		# 	ap c.to_s, AP_OPTIONS
		# 	ap ""
		# end
		
		# r.activities.map do |a|
		# 	ap a.wrapped_text, AP_OPTIONS
		# 	ap ""
		# end
		
		%w(genre all_things).map do |m|
			ap r.send(m)
		end
		ap ""
	end
	
	
	def self.show_character c 
		ap c.name
		ap c.about
		ap ""		
	end
	
	
	def self.show_activity a
		%w(camera_plan camera_direction duration lighting space things non_diegetic_sound).map do |m|
			ap a.send(m)
		end
		
		ap a.wrapped_text
		ap ""		
	end
end