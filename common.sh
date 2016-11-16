#!/bin/bash

## Install common/shared stuff
cd common

### profile
./profile.sh

## RVM
echo "Installing RVM and a recent ruby"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "Done with RVM"

## Vim-plug
./vim.sh

## Install Powerline custom fonts
cd fonts
./install.sh
cd ..


# sublime
./sublime.sh

# node
./node.sh

## Ember dev
npm install -g bower ember-cli phantomjs

## done common stuff
cd ..
