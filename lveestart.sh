#!/bin/bash
Ubuntu=$(uname -a | grep -oi Ubuntu)
Fedora=$(uname -a | grep -oi Fedora)
if [[ $Ubuntu = "Ubuntu" ]]
then sudo apt-get install git curl libmysqlclient-dev libpq-dev libev-dev; fi
if [[ $Fedora = "fedora" ]]
then sudo dnf install  libxml2-devel libmysqlclient-devel git curl; fi

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
#pwd
git clone https://github.com/lvee/lvee-engine
cd lvee-engine/
#git checkout staging
rvm install $(cat .ruby-version) #может быть долго
rvm use $(cat .ruby-version)
gem install bundler
bundle install
touch config/databasemy.yml
cat config/database.yml | sed  's/P@ssw0rd/12345/g' > config/databasemy.yml
mv config/databasemy.yml config/database.yml
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch = "staging" ]]; then bundle exec rails bootstrap; fi
if [[ $branch = "master" ]]; then bundle exec rake bootstrap; fi
bundle exec rails s
#bundle exec rake db:drop:all
