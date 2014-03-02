require './application'
require 'sass/plugin/rack'

set :public_folder, Proc.new { File.join(root, "public") }

# set :css_folder, Proc.new { File.join(root, "public", "css") }

Sass::Plugin.options[:style] = :compressed
# Sass::Plugin.options[:css_location] = css_folder
use Sass::Plugin::Rack

run Sinatra::Application