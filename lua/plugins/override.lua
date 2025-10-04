---@module 'noice'
vim.defer_fn(function()
  vim.cmd([[set cmdheight=1]])
end, 1000)

local experimental_cmp = true

return {
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "lazyvim.plugins.extras.coding.blink", enabled = experimental_cmp },
  { "ibhagwan/fzf-lua", enabled = false },
  {
    "saghen/blink.cmp",
    enabled = experimental_cmp,

    opts = function(_, optsOld)
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      local opts = optsOld
      -- opts.signature.enabled = true

      opts.keymap = {
        -- or super tab maybe?
        preset = "super-tab",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        -- ["<C-e>"] = {"close", "fallback"},
        -- ["<C-y>"] = {"close", "fallback"},
        -- ["<CR>"] = {"confirm", "fallback"},
        -- ["<C-Space>"] = {"complete", "fallback"},
        -- ["<Tab>"] = {"complete", "fallback"},
        -- ["<S-Tab>"] = {"complete", "fallback"},
        -- ["<C-n>"] = {"select_next", "fallback"},
        -- ["<C-p>"] = {"select_prev", "fallback"},
      }
      -- TODO: check if this is necessary
      opts.completion.accept.auto_brackets.enabled = false
      opts.completion.ghost_text.enabled = false
      -- TODO: remove this again if ticket is closed - https://github.com/Saghen/blink.cmp/issues/1247
      -- opts.completion.accept.dot_repeat = false
      opts.keymap["<Tab>"] = {
        function(cmp)
          prochri.without_neovide_animation()
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      }
      opts.keymap["<Down>"] = {
        function(cmp)
          prochri.without_neovide_animation()
          cmp.scroll_documentation_down()
          return cmp.select_next()
        end,
        "fallback",
      }
      opts.keymap["<Up>"] = {
        function(cmp)
          prochri.without_neovide_animation()
          return cmp.select_prev()
        end,
        "fallback",
      }
      return opts
    end,
  },
  { import = "lazyvim.plugins.extras.coding.luasnip" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- opts.incremental_selection.keymaps.init_selection = "<CR>"
      -- opts.incremental_selection.keymaps.node_incremental = "<CR>"
      -- opts.incremental_selection.keymaps.scope_incremental = "<C-space>"
      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.preset = "classic"
      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.scroll.enabled = false
      opts.input.enabled = false
      opts.picker = opts.picker or {}
      opts.picker.win.input.keys["<Esc>"] = { "close", mode = { "n", "i" } }
      -- ui select has no recency support in
      opts.picker.ui_select = false
      -- opts.picker.matcher.frecency = true
      opts.picker.layout = { preset = "ivy", layout = { position = "bottom" } }
      opts.words = {
        debounce = 300,
      }
      return opts
    end,
  }, -- { "rcarriga/nvim-notify", enabled = false },
  {
    "folke/noice.nvim",
    enabled = false,
    opts = function(_, opts)
      opts.presets.bottom_search = false
      ---@type NoiceRouteConfig[]
      local routes = {
        {
          view = "notify",
          filter = {
            event = "notify",
            kind = "error",
            find = "vtsls.*inlayHint",
          },
          opts = { skip = true },
        },
      }
      for _, route in ipairs(routes) do
        table.insert(opts.routes, route)
      end
      return opts
    end,
  }, -- { "folke/trouble.nvim", enabled = false },
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.custom_textobjects.f = opts.custom_textobjects.u
      opts.custom_textobjects.F = opts.custom_textobjects.U
      opts.custom_textobjects.c = opts.custom_textobjects.u
      opts.custom_textobjects.C = opts.custom_textobjects.U
      -- opts.custom_textobjects.t = ai.gen_spec.treesitter({
      --   a = "@jsxtag.outer",
      --   i = "@jsxtag.inner",
      -- })
      opts.search_method = "cover"
    end,
  },
  { "folke/tokyonight.nvim", opts = { style = "storm", light_style = "day" } },
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
                filetype = {
                  "neo-tree",
                  "neo-tree-popup",
                  "notify",
                  "OverseerList",
                  "edgy",
                },
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
      table.insert(old_keys, {
        "<leader>ft",
        "<leader>fe",
        desc = "Explorer NeoTree (root dir)",
        remap = true,
      })
      table.insert(old_keys, {
        "<leader>fT",
        "<leader>fE",
        desc = "Explorer NeoTree (cwd)",
        remap = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- keys[#keys + 1] = { "K", "<cmd>lua _G.prochri.smart_hover()<cr>" }
      keys[#keys + 1] = { "K", false }
    end,
    -- opts = function(_spec, opts)
    --   opts.inlay_hints = {
    --     enabled = true,
    --   }
    --   return opts
    -- end,
  },
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    enabled = not experimental_cmp,
    -- branch = "perf",
    dependencies = {
      "hrsh7th/cmp-emoji",
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.experimental = { ghost_text = false }
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } }))
      opts.sources = vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } })
      opts.mapping["<C-j>"] = cmp.mapping(
        cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
        }),
        { "i" }
      )
      opts.mapping["<C-k>"] = cmp.mapping(
        cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Select,
        }),
        { "i" }
      )
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
      opts.mapping["<C-Enter>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert })
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
      require("cmp_git").setup({ filetypes = { "NeogitCommitMessage" } })
      require("cmp").setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "cmp-dbee" },
          { name = "buffer" },
          { name = "git" },
        },
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
