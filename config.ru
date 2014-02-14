require './application'

set :public_folder, Proc.new { File.join(root, "public") }

run Sinatra::Application