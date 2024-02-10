return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    event = "VeryLazy",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- don't setup tsserver automatically with lspconfig
      opts.servers.tsserver.setup = true
      opts.servers.tsserver.autostart = false
      return opts
    end,
  },
}
