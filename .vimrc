set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'marijnh/tern_for_vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'groenewege/vim-less'
Plugin 'Shougo/neomru.vim'
Plugin 'tpope/vim-commentary'
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'romainl/Apprentice'
Plugin 'thomd/vim-wasabi-colorscheme'
call vundle#end()            " required
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
set background=dark     " you can use `dark` or `light` as your background
syntax on
color wasabi256

"lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \   'readonly': '%{&readonly?"x":""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }
"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>

"unite config
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <space><space> :Unite -start-insert -auto-resize file file_rec/async file_mru <CR>
nnoremap <space>/ :Unite grep:.<CR>
if executable('ag')
	let g:unite_source_grep_command='ag'
	let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
	let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
	let g:unite_source_grep_command='ack'
	let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
	let g:unite_source_grep_recursive_opt=''
endif

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-h> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction
"Ternf
nnoremap <C-]> :TernDef<CR>

"Tabs
set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Indents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
"folds copyright
function! FoldCopyRight()
  let thisline = getline(v:lnum)
  if match(thisline, '^\/\*') >= 0
    return ">1"
  elseif match(thisline, '\*\/$') >= 0
    return "<1"
  else
    return "="
  endif
 endfunction
set foldmethod=expr
set foldexpr=FoldCopyRight()

" source ~/DisableNonCountedBasicMotions.vim
set relativenumber
let g:vim_markdown_frontmatter=1

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
