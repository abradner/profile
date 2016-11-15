#! /bin/bash

## Install Mac-specific stuff
cd mac

## Preparing the dock and Finder
./dock.sh

## Xcode / CLT
echo "Making sure command-line tools are ready"
./osx-vm-templates/scripts/xcode-cli-tools.sh
echo "Making sure license agreement is accepted, running `sudo git`"
sudo git
echo "Done with Xcode/CLT"

# Monokai terminal profile
echo "Installing Monokai terminal profile"
open monokai.terminal/Monokai.terminal

# Homebrew
echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "Homebrew complete"

# Installing standard packages
brew install \
  caskroom/cask/brew-cask \
  gpg \
  macvim \
  node \
  openssl \
  postgis \
  # postgresql
  python \
  redis \
  unrarx
  watchman \
  wget \
  youtube-dl \

  android-platform-tools \
  byobu \
  htop \
  iftop \

  aws-elasticbeanstalk \
  aws-cli \

;

# Installing standard apps
brew tap caskroom/versions;
# brew cask install \
#   1password \
#   bartender \
#   copy \
#   crashplan \
#   divvy \
#   dropbox \
#   firefox \
#   flux \
#   google-chrome \
#   java \
#   jewelrybox \
#   mongodb \
#   mongodbpreferencepane \
#   mongohub \
#   osxfuse \
#   rubymine \
#   sabnzbd \
#   skype \
#   sourcetree \
#   spotify \
#   sublime-text-dev \
#   transmission \
#   vlc \
#   vmware-fusion \
#   vyprvpn \
#   webstorm \
# ;

# #Install ntfs-3g
# # Might need sudo nvram boot-args="rootless=0" and reboot
# brew install homebrew/fuse/ntfs-3g
# sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
# sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs



# QuickLook Plugins
brew cask install \
  qlcolorcode \
  qlstephen \
  qlmarkdown \
  quicklook-json \
  qlprettypatch \
  quicklook-csv \
  betterzipql \
  qlimagesize \
  webpquicklook \
  suspicious-package

cd ..
## End Mac-specific stuff

## Install common/shared stuff
./common.sh
