return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.vtsls.settings.vtsls.autoUseWorkspaceTsdk = true
      return opts
    end,
  },
  -- using the old lazyvim typescript
  -- { import = "plugins.extras.lang.typescript_lazyvim_old" },
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
