" =============================================================================
" Vim Configuration File
" =============================================================================

" Essential Settings
" =============================================================================
set nocompatible                " Disable vi compatibility
syntax enable                   " Enable syntax highlighting
filetype plugin indent on      " Enable file type detection and plugins

" Display and Interface
" =============================================================================
set number                      " Show line numbers
set relativenumber             " Show relative line numbers
set ruler                       " Show cursor position
set showcmd                     " Show command in status line
set showmatch                   " Highlight matching brackets
set cursorline                  " Highlight current line
set wildmenu                    " Enhanced command completion
set wildmode=longest:full,full  " Command completion behavior
set laststatus=2                " Always show status line
set title                       " Set terminal title

" Colors and Theme
" =============================================================================
set background=dark             " Use dark background
colorscheme default             " Use default colorscheme (change if needed)
set t_Co=256                    " Enable 256 colors

" Search Settings
" =============================================================================
set hlsearch                    " Highlight search results
set incsearch                   " Incremental search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive if uppercase used

" Indentation and Formatting
" =============================================================================
set autoindent                  " Auto indent new lines
set smartindent                 " Smart indentation
set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Tab width
set shiftwidth=4                " Indent width
set softtabstop=4               " Soft tab width
set textwidth=80                " Line width
set wrap                        " Wrap long lines

" File Handling
" =============================================================================
set autoread                    " Auto reload changed files
set hidden                      " Allow hidden buffers
set encoding=utf-8              " Use UTF-8 encoding
set fileencoding=utf-8          " File encoding
set backspace=indent,eol,start  " Better backspace behavior

" Auto reload files when changed on disk
" Trigger autoread when changing buffers or coming back to vim
au FocusGained,BufEnter * :silent! !
" Trigger autoread when cursor stops moving
au CursorHold,CursorHoldI * :silent! checktime

" Backup and Undo
" =============================================================================
set backup                      " Enable backups
set backupdir=~/.vim/backup//   " Backup directory
set directory=~/.vim/swap//     " Swap file directory
set undofile                    " Persistent undo
set undodir=~/.vim/undo//       " Undo directory

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p")
endif

" Performance
" =============================================================================
set lazyredraw                  " Don't redraw during macros
set synmaxcol=200              " Limit syntax highlighting for long lines
set updatetime=300              " Faster completion

" Mouse and Clipboard
" =============================================================================
set mouse=a                     " Enable mouse in all modes
set clipboard=unnamedplus       " Use system clipboard (Linux)

" Key Mappings and Leader
" =============================================================================
let mapleader = ","             " Set leader key to comma

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>Q :q!<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Toggle features
nnoremap <leader>n :set number!<CR>
nnoremap <leader>r :set relativenumber!<CR>
nnoremap <leader>p :set paste!<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Buffer navigation
nnoremap <leader>b :buffers<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" Quick editing of vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Better line movement
nnoremap j gj
nnoremap k gk

" Easier indentation
vnoremap < <gv
vnoremap > >gv

" Center search results
nnoremap n nzz
nnoremap N Nzz

" File explorer
nnoremap <leader>e :Explore<CR>
nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>s :Sexplore<CR>

" Developer Features
" =============================================================================

" Auto-pairs for brackets and quotes
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Better status line
set statusline=%f%m%r%h%w\ [%Y]\ [%{&ff}]\ %p%%\ %l:%c

" Show whitespace characters
set list
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×

" Auto commands
augroup VimrcGroup
  autocmd!
  " Return to last cursor position when opening files
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  
  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e
  
  " Auto-reload vimrc when saved
  autocmd BufWritePost .vimrc source %
augroup END

" Programming language specific settings
augroup ProgLang
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType javascript,typescript,json setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType html,css,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" Netrw (file explorer) improvements
let g:netrw_banner = 0          " Remove banner
let g:netrw_liststyle = 3       " Tree view
let g:netrw_browse_split = 4    " Open in previous window
let g:netrw_altv = 1           " Open splits to the right
let g:netrw_winsize = 25        " Width of explorer

" Folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Quick fix and location list
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>

" Plugin Management
" =============================================================================
" vim-plug is installed, run :PlugInstall to install plugins

call plug#begin('~/.vim/plugged')

" Essential plugins
Plug 'tpope/vim-sensible'          " Sensible defaults
Plug 'tpope/vim-surround'          " Surround text objects
Plug 'tpope/vim-commentary'        " Easy commenting
Plug 'tpope/vim-fugitive'          " Git integration

" File management
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'            " Fuzzy finder
Plug 'preservim/nerdtree'          " File tree
Plug 'ryanoasis/vim-devicons'      " File icons
Plug 'Xuyuanp/nerdtree-git-plugin' " Git status in NERDTree

" Language support
Plug 'sheerun/vim-polyglot'        " Language pack
Plug 'dense-analysis/ale'          " Linting and fixing

" Appearance
Plug 'vim-airline/vim-airline'     " Status line
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'             " Color scheme

" Productivity
Plug 'jiangmiao/auto-pairs'        " Auto-close brackets
Plug 'honza/vim-snippets'          " Snippets
Plug 'SirVer/ultisnips'            " Snippet engine
Plug 'mhinz/vim-startify'          " Start screen with recent files

call plug#end()

" Plugin-specific settings
" =============================================================================

" Set background before colorscheme
set background=dark

" Apply gruvbox colorscheme (must be after plug#end())
if has('syntax')
    syntax enable
endif

" Ensure gruvbox is loaded
colorscheme gruvbox

" Fix gruvbox colors for terminal
if !has('gui_running')
    set t_Co=256
endif

" NERDTree Configuration
" =============================================================================
" Toggle NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" NERDTree settings
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeMapActivateNode = "l"
let g:NERDTreeMapCloseDir = "h"

" Close vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open NERDTree when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" NERDTree Git Plugin
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" FZF Configuration
" =============================================================================
" FZF key mappings
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>bt :BTags<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>hf :History:<CR>
nnoremap <leader>hs :History/<CR>

" FZF settings
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Respect gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

" FZF colors to match gruvbox
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Airline Configuration
" =============================================================================
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#ale#enabled = 1

" ALE Configuration
" =============================================================================
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1

" Startify Configuration
" =============================================================================
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   Recent Files'] },
      \ { 'type': 'dir',       'header': ['   Recent Files in '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
      \ ]

" Additional File Operation Shortcuts
" =============================================================================

" Quick file creation
nnoremap <leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

" Split window and open file
nnoremap <leader>vs :vs<CR>:Files<CR>
nnoremap <leader>sp :sp<CR>:Files<CR>

" Tab management
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tm :tabmove<Space>

" Quick buffer switching
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>

" Close buffer without closing window
nnoremap <leader>bd :bp\|bd #<CR>

" Find and replace in project
nnoremap <leader>S :%s/\<<C-r><C-w>\>/

" Updated Shortcuts Reference
" =============================================================================
" Leader key: ,
" 
" File Explorer (NERDTree):
" ,t - Toggle NERDTree file explorer
" ,nf - Find current file in NERDTree
" 
" File Finding (FZF):
" ,f - Find files in project
" ,F - Find git files
" ,g - Search text in files (ripgrep)
" ,l - Search lines in current file
" ,bl - Search lines in current buffer
" ,h - Recent files history
" ,hf - Command history
" ,hs - Search history
" 
" Quick actions:
" ,w - Save file
" ,q - Quit
" ,x - Save and quit
" ,Q - Force quit
" 
" Navigation:
" Ctrl+h/j/k/l - Move between splits
" ,e - File explorer (netrw)
" ,v - Vertical file explorer
" ,s - Horizontal file explorer
" 
" File Operations:
" ,nf - Create new file in current directory
" ,vs - Vertical split + file finder
" ,sp - Horizontal split + file finder
" 
" Tabs:
" ,tn - New tab
" ,tc - Close tab
" ,to - Close other tabs
" Tab/Shift+Tab - Next/previous buffer
" 
" Toggles:
" ,n - Toggle line numbers
" ,r - Toggle relative numbers
" ,p - Toggle paste mode
" ,/ - Clear search highlight
" 
" Editing:
" Space - Toggle fold
" < > - Indent/unindent (visual mode)
" ,S - Find and replace word under cursor
" 
" Buffers:
" ,b - List buffers
" ,bn - Next buffer
" ,bp - Previous buffer
" ,bd - Delete buffer (keep window)