#!/bin/bash
#до скрипта нужно создать файл lib/tasks/export_languages.rake и скопировать туда код отсюда https://gist.github.com/alex-liberty/7556b55e60397893b034eb8033e2fada
cp yml/*yml config/locales/
bundle exec rake db:drop:all
bundle exec rails bootstrap
bundle exec rake export_languages
mkdir ymlaftertask
cp tmp/*yml ymlaftertask/
diff -r ymlaftertask/ yml/ > diff.txt
bundle exec rake db:drop:all
