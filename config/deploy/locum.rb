role :app, %w(hosting_soobscha@calcium.locum.ru)
role :web, %w(hosting_soobscha@calcium.locum.ru)
role :db, %w(hosting_soobscha@calcium.locum.ru)

set :ssh_options, forward_agent: true
set :rails_env, :production
