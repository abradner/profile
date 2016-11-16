#!/bin/bash

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