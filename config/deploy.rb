require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :domain, ENV['DOMAIN'] || '127.0.0.1'
set :user, ENV['REMOTE_USER'] || 'springstorm'
set :deploy_to, "/media/files/lveemina"
set :repository, 'https://github.com/lvee/lvee-engine.git'
set :branch, ENV['BRANCH'] || 'master'

set :app_path,   "#{fetch(:current_path)}"

set :shared_paths, ['log/', 'tmp/', 'public/']
set :shared_files, ["config/database.yml", "config/initializers/constants.rb", "config/environments/development.rb"]
set :rails_env, 'development'

#set :port, '22'
#set :ssh_options, '-A'

task :environment do
  invoke :'rvm:use', ENV['RUBY'] || 'ruby-2.3.3@default'
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    command "#{fetch (:bundle_prefix)} rake db:drop:all"
    command "#{fetch (:bundle_prefix)} rake bootstrap"
    invoke :'rails:assets_precompile'
  end
end
