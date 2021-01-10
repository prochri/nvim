let mapleader = ' '
"TODO choose finder between coc and lsp

" leader mappings
nnoremap <leader><leader> <cmd>call EasyLister('commands')<cr> 

nnoremap <leader>m :w<cr>:make<cr>
nnoremap <leader>' <cmd>FloatermToggle getenv('SHELL')<cr>

" file mappings
nnoremap <leader>ff <cmd>call EasyLister('files')<cr>
nnoremap <leader>fs <cmd>w<cr>
nnoremap <leader>fS <cmd>wa<cr>
" TODO
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
" nnoremap <leader>ft :NERDTreeToggle<cr>

" vim config
nnoremap <leader>vr :call LoadRelative('init.vim')<cr>
" TODO use g:vim_config_root
nnoremap <leader>vf :lua require'telescope.builtin'.find_files{cwd = os.getenv('HOME') .. '/.config/nvim/'}<cr>
nnoremap <leader>vs :source %<cr>
nnoremap <leader>vl :luafile %<cr>

" window commands
nnoremap <leader>wd :hide<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>ws :split<cr>
nnoremap <leader>wh <c-w><c-h>
nnoremap <leader>wj <c-w><c-j>
nnoremap <leader>wk <c-w><c-k>
nnoremap <leader>wl <c-w><c-l>

" help
" nnoremap <leader>hm <cmd>call <cr> man pages
nnoremap <leader>hv <cmd>call EasyLister('helptags')<cr>
nnoremap <leader>hk <cmd>call EasyLister('keymaps')<cr>

" search
nnoremap <leader>sd <cmd>call EasyLister('grep')<cr>
nnoremap <leader>sp <cmd>call EasyLister('grep')<cr>
nnoremap <leader>sb <cmd>call EasyLister('lines')<cr>


" project
nnoremap <leader>pf <cmd>call EasyLister('files')<cr>
nnoremap <leader>pp <cmd>call EasyLister('projects')<cr>

" git
nnoremap <leader>gg <cmd>FloatermNew --name=layzgit --autoclose=1 --width=1.0 --height=1.0 lazygit<cr>
nnoremap <leader>gs <cmd>FloatermNew --name=layzgit --autoclose=1 --width=1.0 --height=1.0 lazygit<cr>

" buffer mappings
nnoremap <leader>bb <cmd>call EasyLister('buffers')<cr>
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprev<cr>
" with vim-bbye
nnoremap <leader>bd :Bdelete<cr>

nnoremap <leader>tw :set wrap!<cr>
nnoremap <leader>tn :set number! relativenumber!<cr>

" quit stuff
nnoremap <leader>qq :qall<cr>
