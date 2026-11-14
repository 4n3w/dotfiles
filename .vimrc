autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType go setlocal ts=4 sts=4 sw=4 
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

syntax on

set visualbell

set nu
set encoding=utf-8
set fileencoding=utf-8

set shiftwidth=4

set undofile
set undodir=~/.vim/undodir

set rtp+=/opt/homebrew/opt/fzf

filetype plugin indent on
