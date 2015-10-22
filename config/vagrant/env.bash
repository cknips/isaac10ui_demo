#!/usr/bin/env bash

export PROJECT_NAME='isaac10ui_demo'

alias x-start="cd /vagrant; tmuxinator start $PROJECT_NAME"
alias r-server="bundle exec rails s"
alias r-console="bundle exec rails c"
alias r-migrate="bundle exec rake db:migrate; bundle exec rake db:migrate RAILS_ENV=test"
alias c="clear"

export ARCHFLAGS='-arch x86_64'
export EXECJS_RUNTIME='Node'
export PS1='\e[0;30;42mVAGRANT ($PROJECT_NAME)\e[m\e[0;34m \w\e[m\r\n$ '
