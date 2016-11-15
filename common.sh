#!/bin/bash

## Install common/shared stuff
cd common

### profile
echo 'Backing up old .profile / .bashrc'
if [ -f ~/.profile ]; then
   mv ~/.profile ~/.profile.backup
fi

if [ -f ~/.bashrc ]; then
   mv ~/.bashrc ~/.bashrc.backup
fi

echo "Linking profile/env"
ln -s `pwd`/.profile ~/.profile
ln -s `pwd`/.environment ~/.environment

## RVM
echo "Installing RVM and a recent ruby"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "Done with RVM"

## Vim-plug
echo "Installing Vim-Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Linking .vimrc"
if [ -f ~/.vimrc ]; then
   mv ~/.vimrc ~/.vimrc.backup
fi
ln -s `pwd`/.vimrc ~/.vimrc


## Install Powerline custom fonts
cd fonts
./install.sh
cd ..

## Vimified
# curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh

# Use powerline fonts for powerline
# echo "let g:airline_powerline_fonts = 1" >> ~/.vim/after.vimrc




## Ember dev
npm install -g bower ember-cli phantomjs

## done common stuff
cd ..
