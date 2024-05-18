return {
  { import = "lazyvim.plugins.extras.coding.mini-ai" },
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects.f = opts.custom_textobjects.u
      opts.custom_textobjects.F = opts.custom_textobjects.U
      opts.custom_textobjects.c = opts.custom_textobjects.u
      opts.custom_textobjects.C = opts.custom_textobjects.U
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      light_style = "day",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify", "OverseerList", "edgy" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    keys = function(spec, old_keys)
      table.remove(old_keys)
      table.remove(old_keys)
      table.insert(old_keys, { "<leader>ft", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true })
      table.insert(old_keys, { "<leader>fT", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- keys[#keys + 1] = { "K", "<cmd>lua _G.prochri.smart_hover()<cr>" }
      keys[#keys + 1] = { "K", false }
    end,
    opts = function(_spec, opts)
      opts.inlay_hints = {
        enabled = true,
      }
      return opts
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji", { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } } },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.experimental = {
        ghost_text = false,
      }
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } }))
      opts.sources = vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } })
      opts.mapping["<C-j>"] =
        cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" })
      opts.mapping["<C-k>"] =
        cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" })
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }
          local is_insert_mode = function()
            ---@diagnostic disable-next-line: undefined-field
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then -- prevent overwriting brackets
            confirm_opts.behavior = cmp.ConfirmBehavior.Insert
          end
          if cmp.confirm(confirm_opts) then
            return -- success, exit early
          end
        end
        fallback() -- if not exited early, always fallback
      end)
      opts.mapping["<C-h>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.abort()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end)
      opts.mapping["<C-l>"] = cmp.mapping(function(_)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end)
      opts.mapping["<C-d>"] = cmp.mapping.scroll_docs(4)
      opts.mapping["<C-u>"] = cmp.mapping.scroll_docs(-4)
      opts.mapping["<CR>"] = nil
    end,
    init = function(_)
      require("cmp_git").setup({
        filetypes = { "NeogitCommitMessage" },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },
      })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "~/.config/nvim/snippets" },
      })
    end,
    keys = function(_, _)
      return {
        {
          "<C-h>",
          function()
            print("jumpable back", require("luasnip").jumpable(-1))
            require("luasnip").jump(-1)
          end,
          mode = "s",
        },
        {
          "<C-l>",
          function()
            require("luasnip").jump(1)
          end,
          mode = "s",
        },
      }
    end,
  },
}
