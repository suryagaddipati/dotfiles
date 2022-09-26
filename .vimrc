
filetype plugin indent on    " required

"housekeeping
set nobackup
set noswapfile
"leader
let mapleader=","

"remap esc
inoremap jk <Esc>
"split switching
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"color
set background=light     " you can use `dark` or `light` as your background
syntax on


"Tabs
set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Indents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
set relativenumber

"Remember last postion in file 
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction
filetype indent on
set smartindent
autocmd BufRead,BufWritePre *.jsx normal gg=G `` zz

"netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" ctrl p
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
