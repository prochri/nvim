local Util = require("lazyvim.util")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(spec, old_opts)
      local lualine_c = old_opts.sections.lualine_c
      local function mypretty_path(self)
        local path = vim.fn.expand("%:p") --[[@as string]]

        if path == "" then
          return ""
        end
        local root = Util.root.get({ normalize = true })
        local cwd = Util.root.cwd()

        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        else
          path = path:sub(#root + 2)
        end
        return path
      end
      lualine_c[#lualine_c] = mypretty_path
      return old_opts
    end,
  },
  {
    "folke/noice.nvim",
    ---@param old_opts NoiceConfig
    opts = function(_, old_opts)
      if not old_opts.lsp then
        ---@diagnostic disable-next-line: inject-field
        old_opts.lsp = {}
      end
      if not old_opts.lsp.hover then
        old_opts.lsp.hover = {}
      end
      old_opts.lsp.hover.opts = {
        close = {
          keys = { "q", "<Esc>" },
        },
      }
      return old_opts
    end,
  },
  { import = "lazyvim.plugins.extras.ui.edgy" },
  {
    "folke/edgy.nvim",
    ---@param opts Edgy.Config
    opts = function(_, opts)
      if not opts.animate then
        ---@diagnostic disable-next-line: inject-field
        opts.animate = {}
      end
      opts.animate.enabled = false
      -- opts.animate.cps = 180

      opts.left = vim.tbl_filter(function(item)
        return item.title ~= "Neo-Tree Git" and item.title ~= "Neo-Tree Buffers"
      end, opts.left)
      table.insert(opts.left, {
        title = "Overseer",
        ft = "OverseerList",
        pinned = true,
        open = "OverseerOpen",
      })
      return opts
    end,
    config = function(_, opts)
      require("edgy").setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "float",
      float_opts = {
        border = "none",
      },
    },
  },
  {
    "voldikss/vim-floaterm",
  },
  { "FabijanZulj/blame.nvim" },
  -- {
  --   "soulis-1256/hoverhints.nvim",
  --   opts = true,
  -- },
}
