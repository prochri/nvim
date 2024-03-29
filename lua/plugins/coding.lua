return {
  {
    "t-troebst/perfanno.nvim",
    event = "VeryLazy",
    opts = true,
  },
  -- often used for parsing json5 files from vscode
  {
    "Joakker/lua-json5",
    build = "./install.sh",
    lazy = true,
    config = function()
      require("json5")
    end,
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
