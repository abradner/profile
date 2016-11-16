#!/bin/bash

SUBL_PATH_OSX=~/Library/Application Support/Sublime Text 3/
SUBL_PATH_LINUX=~/Library/Application Support/Sublime Text 3/

if [ "$(uname)" == "Darwin" ]; then
	SUBL_PATH=$SUBL_PATH_OSX
else
	SUBL_PATH=$SUBL_PATH_LINUX
fi

echo "Installing Package Control for sublime 3"
echo "using directory $SUBL_PATH"

curl -fLo $SUBL_PATH/Installed\ Packages/Package\ Control.sublime-package --create-dirs \
    https://packagecontrol.io/Package%20Control.sublime-package

echo "Installing basic sublime config"
if [ -f $SUBL_PATH/Packages/User/Package\ Control.sublime-settings ]; then
   mv $SUBL_PATH/Packages/User/Package\ Control.sublime-settings \
   $SUBL_PATH/Packages/User/Package\ Control.sublime-settings.backup
else
	mkdir -p $SUBL_PATH/Packages/User	
fi

ln -s `pwd`/Package\ Control.sublime-settings $SUBL_PATH/Packages/User/Package\ Control.sublime-settings

echo "Sublime done"