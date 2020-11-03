#!/bin/bash

ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/vim/.vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/idea/.ideavimrc $HOME/.ideavimrc

ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
mkdir -p $HOME/.config/git/ 2>/dev/null
ln -s $HOME/dotfiles/.gitignore $HOME/.config/git/ignore
