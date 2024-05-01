return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  {
    "marilari88/twoslash-queries.nvim",
    config = function(_, opts)
      require("twoslash-queries").setup({
        highlight = "Debug",
      })
      require("lazyvim.util.lsp").on_attach(function(client, bufnr)
        if client.name ~= "tsserver" then
          return
        end
        require("twoslash-queries").attach(client, bufnr)
      end)
    end,
  },
  --- using typescript tools
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  --- using vstls
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = { "yioneko/nvim-vtsls" },
  --   opts = function(_, opts)
  --     -- don't setup tsserver automatically with lspconfig
  --     opts.servers.tsserver.setup = true
  --     opts.servers.tsserver.autostart = false
  --
  --     opts.servers.vtsls = require("vtsls").lspconfig
  --     -- setup vtsls
  --     opts.servers.vtsls.settings = {
  --       vtsls = {
  --         autoUseWorkspaceTsdk = true,
  --       },
  --       completions = {
  --         completeFunctionCalls = true,
  --       },
  --     }
  --     -- require("lspconfig").vtsls.setup()
  --     return opts
  --   end,
  -- },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     table.insert(opts.ensure_installed, "vtsls")
  --   end,
  -- },
}
