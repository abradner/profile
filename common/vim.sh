#!/bin/bash

echo "Installing Vim-Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Linking .vimrc"
if [ -f ~/.vimrc ]; then
   mv ~/.vimrc ~/.vimrc.backup
fi
ln -s `pwd`/.vimrc ~/.vimrc


## Vimified
# curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh

# Use powerline fonts for powerline
# echo "let g:airline_powerline_fonts = 1" >> ~/.vim/after.vimrc
