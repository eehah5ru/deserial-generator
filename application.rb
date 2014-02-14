require 'sinatra'
require 'slim'
require 'yaml'
require_relative "lib/characters_generator.rb"

get '/characters' do
  slim :characters_form
end


post '/characters' do
  
  CharacterBuilder::Options.create!

  builder = CharacterBuilder.new(DataSource.new("data/characters.yml"))
  
  @characters = []
  
  params[:characters_count].to_i.times do |i|
    @characters << builder.build
  end
  
  slim :characters
end

