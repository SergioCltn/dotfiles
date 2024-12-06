#!/usr/bin/env bash

echo "Installing Ripgrep, jq, pavucontrol, xclip, git, tldr, shutter, python3-pip"
sudo apt -y update
sudo apt -y install git ripgrep pavucontrol xclip jq tldr shutter python3-pip

echo "Installing FuzzyFinder"
git clone git@github.com:junegunn/fzf.git $HOME/personal/fzf
$HOME/personal/fzf/install
