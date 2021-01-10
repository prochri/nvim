if &shell =~# 'fish$'
    set shell=zsh
endif

syntax on
filetype plugin on
filetype indent on

" TODO check for terminal where this is launched from and set only then this option
set termguicolors
set clipboard+=unnamedplus
set history=1000
" TODO mouse actions for lsp ?
set mouse=a
set number
set relativenumber
set signcolumn=number
set ignorecase
set smartcase
set incsearch
set hlsearch
set lazyredraw
set splitbelow
set splitright
set scrolloff=3
" set foldlevelstart=99
set wrap

" tab and indent behaviour
set autoindent
set smartindent

set backspace=indent,eol,start
set expandtab shiftwidth=2
set hidden

" text information characters
set list
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶
set fillchars=vert:│,fold:·
set showbreak=↪
set linebreak

" command completion menu
set wildmode=longest:full,full
set wildignore=*.o,*.pyc,*.out,*.aux
set wildmenu

" backup files and file management
set autoread
set nowritebackup
set backup
set undofile
set undolevels=1000
let g:home = $HOME
let g:data_dir = g:home.'/.cache/vim/'
let g:backup_dir = g:data_dir . 'backup'
let g:swap_dir = g:data_dir . 'swap'
let g:undo_dir = g:data_dir . 'undofile'
let g:conf_dir = g:data_dir . 'conf'
if finddir(g:data_dir) ==# ''
  silent call mkdir(g:data_dir, 'p', 0700)
endif
if finddir(g:backup_dir) ==# ''
  silent call mkdir(g:backup_dir, 'p', 0700)
endif
if finddir(g:swap_dir) ==# ''
  silent call mkdir(g:swap_dir, 'p', 0700)
vim.o.no
endif
if finddir(g:undo_dir) ==# ''
  silent call mkdir(g:undo_dir, 'p', 0700)
endif
if finddir(g:conf_dir) ==# ''
  silent call mkdir(g:conf_dir, 'p', 0700)
endif
let &undodir = g:undo_dir
let &backupdir = g:backup_dir
let &directory = g:swap_dir
unlet g:home
unlet g:data_dir
unlet g:backup_dir
unlet g:swap_dir
unlet g:undo_dir
unlet g:conf_dir
