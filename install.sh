#!/bin/bash

# Automatically exit this script if any command fails
set -e

echo "Starting vim setup..."

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install silversearcher-ag vim-gnome git

# Install Powerline fonts for nice VCS symbols in vim-airline
if [ ! -e ~/powerline-fonts/install.sh ]
then
    echo "Cloning powerline fonts..."
    git clone https://github.com/powerline/fonts.git ~/powerline-fonts
fi
echo "Installing powerline fonts..."
# Powerline fonts' install.sh only works when run from the directory it lives in
cd ~/powerline-fonts
source install.sh
cd -
echo "Setting Gnome terminal font to Ubuntu Mono for Powerline..."
# Replace "Default" with preferred terminal profile
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type bool false
gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Ubuntu Mono derivative Powerline 13"

# Make directories for vim plugins and persistent undo
echo "Creating required directories..."
mkdir -p ~/.vim/bundle ~/vim-undo

# Clone Vundle to manage plugins
if [ ! -e ~/.vim/bundle/Vundle.vim ]
then
    echo "Cloning vundle..."
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Remove any plugins not specified with Vundle in vimrc
echo "Removing unmanaged plugins..."
vim +PluginClean! +qall

# Install/Update all plugins specified with Vundle in vimrc
echo "Installing/updating managed plugins..."
vim +PluginInstall! +qall

echo "Finished vim setup."
