" TODO 
if has('nvim')
  let s:vim_plug_path = '~/.local/share/nvim/site/autoload/plug.vim'
  let s:vim_plugins_path = stdpath('data') . '/vim-plug/plugged'
else
  " normal vim
  let s:vim_plug_path = '~/.vim/autoload/plug.vim'
  let s:vim_plugins_path = '~/.vim/plugged'
end


" TODO windows path
if empty(glob(s:vim_plug_path))
  echo 'installing'
  if has('win32') || has('win64')
    " TODO does this work?
    let &shell = 'powershell'

    execute 'silent iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ' .
          \ 'ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force'
  else
    execute "silent !curl -fLo " . s:vim_plug_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin(s:vim_plugins_path)

" basics
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
" for auto detecting shifwidth
Plug 'tpope/vim-sleuth'
Plug 'easymotion/vim-easymotion'
Plug 'moll/vim-bbye'

" nvim basics
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
end

" theming and colours {{{
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'
if has('nvim')
  Plug 'kyazdani42/nvim-web-devicons'
  " highlight colors
  Plug 'norcalli/nvim-colorizer.lua'
end
" }}}



" treesitter syntax highlight {{{
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter',
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'nvim-treesitter/completion-treesitter'
else
  " general language support
  Plug 'sheerun/vim-polyglot'
endif
" }}}

" lsp-coc or builtin {{{
if g:use_builtin_lsp
  " snippets
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  " completion
  Plug 'steelsojka/completion-buffers'
  Plug 'nvim-lua/completion-nvim'

  " lsp and formatting
  Plug 'lukas-reineke/format.nvim'
  Plug 'tjdevries/nlua.nvim'
  Plug 'rafcamlet/nvim-luapad'
  Plug 'neovim/nvim-lspconfig'

  " lsp
else
  " coc has its own config file
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug '~/git_repos/coc-generic-list'
  Plug 'honza/vim-snippets'
endif
" }}}

" specific language support
Plug 'dag/vim-fish'
Plug 'lervag/vimtex'
Plug 'masukomi/vim-markdown-folding'

" other utilities
" projects
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
" terminal
Plug 'voldikss/vim-floaterm'
" searcher
if has('nvim')
  Plug 'nvim-lua/telescope.nvim'
endif

call plug#end()
