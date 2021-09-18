" set mouse=a
syntax on
inoremap <C-s> <esc>:w<cr>                 " save files2 nnoremap <C-s> :w<cr> 
inoremap <C-d> <esc>:wq!<cr>               " save and exit
nnoremap <C-d> :wq!<cr>
inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
nnoremap <C-q> :qa!<cr>
" FIX: ssh from wsl starting with REPLACE mode
" https://stackoverflow.com/a/11940894
if $TERM =~ 'xterm-256color'
    set noek
endif
:set number relativenumber
set nocompatible

set background=dark
set termguicolors
let g:quantum_black=1
colorscheme quantum
" :hi Visual term=reverse cterm=reverse guibg=Grey
" highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE

"Remove all trailing whitespace by pressing F5
"nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

nnoremap <F5> <esc>:%s/\s\+$//e<cr>

