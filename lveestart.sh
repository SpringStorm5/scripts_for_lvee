#!/bin/bash
while (( $# > 0 ))
do
    opt="$1"
    shift

    case $opt in

    --folder)
      fold="$1"
      shift
      ;;

    --pass)
      parol="$1"
      shift
      ;;
    --email)
      email="$1"
      shift
      ;;
    --email_pass)
      email_pass="$1"
      shift
      ;;

    --help)
        helpfunc
        exit 0
        ;;
    --version)
        echo "$0 version $version"
        exit 0
        ;;

    --*)
        echo "Invalid option: '$opt'" >&2
        exit 1
        ;;
    *)
        # end of long options
        break;
        ;;
   esac

done

Ubuntu=$(uname -a | grep -oi Ubuntu)
Fedora=$(uname -a | grep -oi Fedora)
if [[ $Ubuntu = "Ubuntu" ]]
then sudo apt-get install git curl nodejs libmysqlclient-dev libpq-dev libev-dev; fi
if [[ $Fedora = "fedora" ]]
then sudo dnf install  git curl nodejs mariadb mariadb-server; fi
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
git clone https://github.com/lvee/lvee-engine $fold
cd $fold #lvee-engine
git checkout staging
rvm install $(cat .ruby-version) #может быть долго
rvm use $(cat .ruby-version)
gem install bundler
bundle install
sed -i "/config.i18n.backend = I18nDatabaseBackend.new/i \  config.action_mailer.raise_delivery_errors = false\n  config.action_mailer.delivery_method = :smtp\n  config.action_mailer.smtp_settings = {\n    :address => 'smtp.gmail.com',\n    :port => '587',\n    :user_name => '$email',\n    :password => '$email_pass',\n    :authentication => 'plain',\n    :enable_starttls_auto => true }\n" $fold/config/environments/development.rb
sed -i "s/P@ssw0rd/$parol/g" $fold/config/database.yml
if [[ $Fedora = "fedora" ]]
    then sudo service mariadb start
else
    sudo service mysql start
fi
cd $fold
"bin/rails db:environment:set RAILS_ENV=development"
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch = "staging" ]]; then bundle exec rails bootstrap; fi
if [[ $branch = "master" ]]; then bundle exec rake bootstrap; fi
sed -i "s/lvee.org/localhost:3000/g" $fold/config/initializers/constants.rb
sed -i "s/https/http/g" $fold/config/initializers/constants.rb
bundle exec rails s
#bundle exec rake db:drop:all

