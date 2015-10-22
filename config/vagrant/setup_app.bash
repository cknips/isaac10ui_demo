#!/usr/bin/env bash


# Copy tmuxinator config
#
mkdir $HOME/.tmuxinator
cp config/vagrant/tmuxinator.yml $HOME/.tmuxinator/isaac10ui_demo.yml


# Setup Rails App
#
cd /vagrant
bundle install
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

cd /vagrant
