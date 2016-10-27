#!/bin/bash
# sudo apt-get install git curl
# sudo apt-get install libmysqlclient-dev libpq-dev libev-dev
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
pwd
cd ..
git clone https://github.com/lvee/lvee-engine
cd lvee-engine/
rvm install $(cat .ruby-version)
rvm use $(cat .ruby-version)
gem install bundler
bundle install
touch config/databasemy.yml
cat config/database.yml | sed  's/P@ssw0rd/12345/g' > config/databasemy.yml
mv config/databasemy.yml config/database.yml
bundle exec rake bootstrap
bundle exec rails s
bundle exec rake db:drop:all
