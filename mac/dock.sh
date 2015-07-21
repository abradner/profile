#!/bin/bash

echo "Making the dock and finder behave nicely"

defaults write com.apple.finder FXPreferredViewStyle Nlsv;
defaults write com.apple.finder ShowStatusBar YES;
defaults write com.apple.finder ShowPathbar YES;
defaults write com.apple.finder ShowSidebar YES;
defaults write com.apple.finder ShowHardDrivesOnDesktop YES;
defaults write com.apple.finder ShowRemovableMediaOnDesktop YES;
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop YES;
defaults write com.apple.finder AppleShowAllFiles YES; # show hidden files
defaults write com.apple.finder QLEnableTextSelection -bool true; # Text selection in quick look

defaults write com.apple.dock persistent-apps -array; # remove icons in Dock
defaults write com.apple.dock tilesize -int 16; # smaller icon sizes in Dock
defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
defaults write com.apple.dock autohide-delay -float 0; # remove Dock show delay
defaults write com.apple.dock autohide-time-modifier -float 0; # remove Dock show delay
defaults write com.apple.dock orientation right; # place Dock on the right side of screen
killall Dock 2>/dev/null;
killall Finder 2>/dev/null;

echo "Done with dock and finder"
