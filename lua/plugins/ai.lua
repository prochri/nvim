return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          panel = { enabled = false },
          suggestion = {
            enabled = true,
            auto_trigger = true,
          },
          filetypes = {
            bigfile = false,
          },
        })
      end, 100)
    end,
  },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup()
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  -- {
  --   "james1236/backseat.nvim",
  --   config = function()
  --     require("backseat").setup({
  --       openai_api_key = os.getenv("OPENAI_API_KEY"),
  --       openai_model_id = "gpt-3.5-turbo",
  --     })
  --   end,
  -- },
}
