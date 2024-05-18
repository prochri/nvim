return {
  {
    "t-troebst/perfanno.nvim",
    event = "VeryLazy",
    opts = true,
  },
  {
    "glepnir/lspsaga.nvim",
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = {
        enable = false,
        sign = true,
        virtual_text = false,
        update_time = 500,
      },
    },
  },
  -- {
  --   "smjonas/inc-rename.nvim",
  --   opts = true,
  -- },
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
