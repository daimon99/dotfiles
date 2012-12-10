#!/bin/bash
# File: rm_git.sh
# Date: Mon Dec 10 23:32:53 2012 +0800
# Author: Yuxin Wu <ppwwyyxxc@gmail.com>
rm .vimrc .vim -r
cp ~/.vimrc ~/.vim ./ -rv
rm .zshrc .aliasrc .zsh -r
cp ~/.zshrc ~/.aliasrc ~/.zsh ./ -rv
mv `find .vim |grep '[git|svn]$' |tr '\n' ' '` ~/.Trash/ --backup=numbered -f
mv `find .vim |grep '\.gitignore$' |tr '\n' ' '` ~/.Trash/ --backup=numbered -f
7z a ../vim.7z ~/.vim
