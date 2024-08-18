return {
  -- { import = "lazyvim.plugins.extras.lang.typescript" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     ---@type lspconfig.settings.vtsls
  --     local settings = opts.servers.vtsls.settings
  --     settings.vtsls.autoUseWorkspaceTsdk = true
  --     settings.vtsls.experimental = settings.vtsls.experimental or {}
  --     settings.vtsls.experimental.maxInlayHintLength = 50
  --     settings.vtsls.experimental.completion = settings.vtsls.experimental.completion or {}
  --     -- this seems to be slower than client side filtering
  --     settings.vtsls.experimental.completion.enableServerSideFuzzyMatch = false
  --     settings.typescript.tsserver = settings.typescript.tsserver or {}
  --     settings.typescript.tsserver.maxTsServerMemory = 10000
  --     -- settings.typescript.watchOptions = {
  --     --   watchFile = "useFsEvents",
  --     --   watchDirectory = "useFsEvents",
  --     -- }
  --
  --     return opts
  --   end,
  -- },
  -- {
  --   "yioneko/nvim-vtsls",
  --   lazy = true,
  --   opts = {},
  --   config = function(_, opts)
  --     require("vtsls").config(opts)
  --   end,
  -- },
  -- using the old lazyvim typescript
  { import = "plugins.extras.lang.typescript_lazyvim_old" },
  {
    "marilari88/twoslash-queries.nvim",
    config = function(_, opts)
      require("twoslash-queries").setup({
        highlight = "Debug",
      })
      require("lazyvim.util.lsp").on_attach(function(client, bufnr)
        if client.name ~= "tsserver" and client.name ~= "vtsls" then
          return
        end
        require("twoslash-queries").attach(client, bufnr)
      end)
    end,
  },
}
