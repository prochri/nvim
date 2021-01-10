local nvim_cmd = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
local first_install = false

if fn.empty(fn.glob(install_path)) > 0 then
  first_install = true
  nvim_cmd(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
nvim_cmd('packadd packer.nvim')

local packer = require('packer')

local is_vscode = 'vim.g.vscode'
local not_is_vscode = 'not ' .. is_vscode

local function use_nvim_only(plgs)
  if type(plgs) == 'string' then
    plgs = {plgs}
  end
  if not plgs.cond then
    plgs.cond = not_is_vscode
  end
  packer.use(plgs)
end

packer.startup(
  function()
    -- packer self management
    packer.use {'wbthomason/packer.nvim', opt = true}
    -- always on plugins
    packer.use {
      'justinmk/vim-sneak', 'tpope/vim-surround', 'tpope/vim-repeat',
      'tpope/vim-sensible'
    }
    packer.use {'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim'}

    use_nvim_only 'morhetz/gruvbox'
    -- use_nvim_only {
    --   'hrsh7th/vim-vsnip',
    --   setup = function()
    --     vim.cmd [[packadd LaTeX-Workshop]]
    --     vim.cmd [[packadd vscode-python-snippet-pack]]
    --   end
    -- }
    -- use_nvim_only 'hrsh7th/vim-vsnip-integ'

    use_nvim_only {
      'neoclide/coc.nvim',
      branch = 'release',
      setup = function() require 'code.coc' end
    }

    -- completion
    -- use_nvim_only {
    --   'nvim-lua/completion-nvim',
    --   requires = {{'steelsojka/completion-buffers', opt = true}},
    --   config = function() require 'code.completion' end
    -- }

    -- lsp config/lua
    use_nvim_only 'lukas-reineke/format.nvim'
    use_nvim_only 'tjdevries/nlua.nvim'
    use_nvim_only 'rafcamlet/nvim-luapad'
    use_nvim_only {
      'neovim/nvim-lspconfig',
      config = function() require 'code.lsp' end
    }

    -- treesitter
    use_nvim_only {
      'nvim-treesitter/nvim-treesitter',
      requires = { -- those dependencies are loaded in my config
        {'nvim-treesitter/nvim-treesitter-refactor', opt = true},
        {'nvim-treesitter/nvim-treesitter-textobjects', opt = true},
        {'nvim-treesitter/completion-treesitter', opt = true}
      },
      config = function() require 'code.treesitter' end
    }

    -- language support
    use_nvim_only 'lervag/vimtex'

    -- TODO
    use_nvim_only {'kyazdani42/nvim-web-devicons'}

    use_nvim_only {'voldikss/vim-floaterm'}

    -- use {'jreybert/vimagit', cond = not_is_vscode}
    -- use {'TimUntersberger/neogit', cond = not_is_vscode}

    -- use {'mhinz/vim-startify', cond = not_is_vscode}

    -- snippets
    -- menu
    use_nvim_only {
      'nvim-lua/telescope.nvim',
      config = function() require 'telescope_extensions' end,
      cond = not_is_vscode
    }
    -- colors
    use_nvim_only {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      after = 'nvim-web-devicons',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require 'statusline' end
    }

    use_nvim_only {'tpope/vim-obsession'}
    use_nvim_only {
      'dhruvasagar/vim-prosession',
      requires = {{'tpope/vim-obsession', opt = true}},
      setup = function()
        vim.cmd [[packadd vim-obsession]]
        vim.g.prosession_on_startup = 0
        vim.g.prosession_dir = '~/.cache/vim/session/'
      end,
      config = function() require 'projects' end
    }

    use_nvim_only 'nathanaelkane/vim-indent-guides'
    use_nvim_only {
      'akinsho/nvim-bufferline.lua',
      after = {'nvim-web-devicons'},
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require'bufferline'.setup() end
    }

    use_nvim_only {
      'norcalli/nvim-colorizer.lua',
      conf = function() require'colorizer'.setup() end
    }

    use_nvim_only {'dag/vim-fish'}
    -- editing
    use_nvim_only {'tpope/vim-commentary'}
    use_nvim_only {'easymotion/vim-easymotion'}

    -- packer.use { -- TODO this should work right? post an issue.
    --   'asvetliakov/vim-easymotion',
    --   as = 'vscode-easymotion',
    --   cond = is_vscode
    -- }
  end)

return first_install
