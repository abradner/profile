#!/bin/bash

## Install common/shared stuff
cd common

### bash_profile
echo "Linking .bash_profile"
ln -s `pwd`/.bash_profile ~/.bash_profile

## RVM
echo "Installing RVM and a recent ruby"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "Done with RVM"


## Install Powerline custom fonts
cd fonts
./install.sh
cd ..

## Vimified
curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh


## Ember dev
npm install -g bower ember-cli

## done common stuff
cd ..
