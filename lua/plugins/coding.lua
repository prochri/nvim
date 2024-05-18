return {
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
