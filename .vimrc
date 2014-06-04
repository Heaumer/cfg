" Set default encoding to utf8
set encoding=utf-8
set fileencoding=utf-8

" Re-map escape key.
map! ii <Esc>

" Go syntax highlighting
filetype off
filetype plugin indent off
set rtp+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" Loading a bepo-compatible keymap.
source ~/.vimrc.bepo

