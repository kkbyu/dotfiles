#!/bin/bash

ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/zsh/.zprofile $HOME/.zprofile
ln -s $HOME/dotfiles/vim/.vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/idea/.ideavimrc $HOME/.ideavimrc
ln -s $HOME/dotfiles/brew/Brewfile $HOME/Brewfile
ln -s $HOME/dotfiles/iterm2/com.googlecode.iterm2.plist $HOME/com.googlecode.iterm2.plist

ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
mkdir -p $HOME/.config/git/ 2>/dev/null
ln -s $HOME/dotfiles/.gitignore $HOME/.config/git/ignore
