#!/bin/bash

ln -s $(pwd)/hypr $HOME/.config/
git clone https://github.com/christitustech/nord-background.git ./tmp
cp -r ./tmp/*.png $HOME/.local/share/omarchy/themes/nord/backgrounds
rm -rf ./tmp
