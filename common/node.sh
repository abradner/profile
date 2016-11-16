#!/bin/bash

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash # https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh

echo "Initialising NVM"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "installing node 7 and setting as default"
nvm install 7 

# echo "Installing node 4 and 5"
# nvm install 4 5

echo "NVM done"