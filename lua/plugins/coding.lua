return {
  { import = "lazyvim.plugins.extras.lsp.neoconf" },
  {
    "saecki/live-rename.nvim",
    lazy = true,
    config = function()
      require("live-rename").setup()
      require("prochri.lsp_rename_save")
    end,
  },
  {
    "t-troebst/perfanno.nvim",
    event = "VeryLazy",
    opts = true,
  },
  {
    "onsails/diaglist.nvim",
    config = function()
      require("diaglist").init({
        debug = false,
        debounce_ms = 150,
      })
    end,
  },
}
