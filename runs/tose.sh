#!/bin/bash

git clone https://github.com/SergioCltn/tose.git ~/personal/tose
cd  ~/personal/tose
git pull --rebase
make build

rm $HOME/.local/bin/tose
cp $HOME/personal/tose/tose $HOME/.local/bin
