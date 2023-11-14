return {
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "mickael-menu/zk-nvim",
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
  },
  -- for latex
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {},
      },
    },
    setup = {
      texlab = function(_, opts)
        p(opts)
        opts.settings = {
          chktex = {
            onEdit = false,
            onOpenAndSave = true,
          },
        }
        return false
      end,
    },
  },
  {
    "lervag/vimtex",
    config = function()
      vim.cmd("filetype plugin indent on")
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_fold_enabled = true
      vim.g.vimtex_compiler_method = "generic"
      vim.g.vimtex_compiler_generic = {
        command = "cd .. && make figures",
      }
      vim.g.vimtex_quickfix_method = "latexlog"
      vim.g.vimtex_quickfix_mode = 0 -- never show the generated quicfix window. diagnostics work better
      vim.g.vimtex_quickfix_ignore_filters = {
        "Unknown document class",
      }
      vim.g.vimtex_syntax_conceal = {
        accents = 0,
        ligatures = 0,
        cites = 0,
        fancy = 0,
        greek = 0,
        math_bounds = 0,
        math_delimiters = 0,
        math_fracs = 0,
        math_super_sub = 0,
        math_symbols = 0,
        sections = 0,
        styles = 0,
      }
    end,
  },
}
