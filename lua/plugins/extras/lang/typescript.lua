local useVtsls = false
local enableTsgo = false

return {
  { import = "lazyvim.plugins.extras.lang.typescript", enabled = useVtsls },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not useVtsls then
        return opts
      end
      ---@type lspconfig.settings.vtsls
      local settings = opts.servers.vtsls.settings
      settings.vtsls.autoUseWorkspaceTsdk = true
      settings.vtsls.experimental = settings.vtsls.experimental or {}
      settings.vtsls.experimental.maxInlayHintLength = 50
      settings.vtsls.experimental.completion = settings.vtsls.experimental.completion or {}
      -- this seems to be slower than client side filtering
      settings.vtsls.experimental.completion.enableServerSideFuzzyMatch = false
      settings.typescript.tsserver = settings.typescript.tsserver or {}
      settings.typescript.tsserver.maxTsServerMemory = 10000
      settings.typescript.tsserver.watchOptions = settings.typescript.tsserver.watchOptions or {}
      settings.typescript.tsserver.watchOptions.watchFile = "useFsEvents"
      settings.typescript.tsserver.watchOptions.watchDirectory = "useFsEvents"

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not enableTsgo then
        return opts
      end
      vim.lsp.config("tsgo_ls", {
        cmd = { "tsgo", "lsp", "-stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      })
      vim.lsp.enable("tsgo_ls")

      return opts
    end,
  },
  -- {
  --   "yioneko/nvim-vtsls",
  --   lazy = true,
  --   opts = {},
  --   config = function(_, opts)
  --     require("vtsls").config(opts)
  --   end,
  -- },
  -- using the old lazyvim typescript
  { import = "plugins.extras.lang.typescript_lazyvim_old", enabled = not useVtsls },
  {
    "marilari88/twoslash-queries.nvim",
    config = function(_, opts)
      require("twoslash-queries").setup({
        highlight = "Debug",
      })
      require("lazyvim.util.lsp").on_attach(function(client, bufnr)
        if client.name ~= "ts_ls" and client.name ~= "vtsls" then
          return
        end
        require("twoslash-queries").attach(client, bufnr)
      end)
    end,
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts.servers.tsserver = { enabled = false }
  --   end,
  -- },
}
