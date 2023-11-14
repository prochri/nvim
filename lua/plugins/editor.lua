return {
  {
    "kylechui/nvim-surround",
    opts = {
      keymaps = {
        -- s in visual is the same as c, so just rebind it for easier access
        visual = "s",
      },
    },
    -- override flash accordingly
    dependencies = {
      "folke/flash.nvim",
      keys = function(spec, old_keys)
        -- stylua: ignore
        local new_keys = {
          { "s",     mode = { "n" },      function() require("flash").jump() end,              desc = "Flash" },
          { "z",     mode = { "o", "x" }, function() require("flash").jump() end,              desc = "Flash" },
          { "S",     mode = { "n" },      function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
          { "Z",     mode = { "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
          { "r",     mode = "o",          function() require("flash").remote() end,            desc = "Remote Flash" },
          { "R",     mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
          { "<c-s>", mode = { "c" },      function() require("flash").toggle() end,            desc =
          "Toggle Flash Search" },
        }
        return new_keys
      end,
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    -- disable mini.pairs as this is a replacement
    dependencies = {
      "echasnovski/mini.pairs",
      enabled = false,
    },
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(spec, opts)
  --     opts.textobjects.swap = {
  --       enable = true,
  --       swap_next = {
  --         ["<M-l>"] = "@parameter.inner",
  --       },
  --       swap_previous = {
  --         ["<M-h>"] = "@parameter.inner",
  --       },
  --     }
  --     return opts
  --   end,
  -- },
  -- {
  --   "nanozuki/tabby.nvim",
  -- },
  {
    "Wansmer/sibling-swap.nvim",
    opts = {
      use_default_keymaps = false,
    },
    -- stylua: ignore
    keys = {
      { "<M-h>", function() require("sibling-swap").swap_with_left() end, mode = { "n", "v" }, },
      { "<M-l>", function() require("sibling-swap").swap_with_right() end, mode = { "n", "v" }, },
    },
  },
  -- {,
  --   "Bekaboo/dropbar.nvim",
  --   opts = {
  --     menu = {
  --       keymaps = {
  --         ["l"] = function()
  --           local menu = require("dropbar.api").get_current_dropbar_menu()
  --           if not menu then
  --             return
  --           end
  --           local cursor = vim.api.nvim_win_get_cursor(menu.win)
  --           local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
  --           if component then
  --             menu:click_on(component, nil, 1, "l")
  --           end
  --         end,
  --         ["h"] = function()
  --           require("dropbar.api").get_current_dropbar_menu():close()
  --         end,
  --       },
  --     },
  --   },
  -- },

  { "ggandor/flit.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = true },
  { "ojroques/nvim-bufdel" },
  -- { "luukvbaal/statuscol.nvim", opts = { setopt = true } },

  -- tasks
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        bindings = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<TAB>"] = "TogglePreview",
          ["q"] = "<cmd>q<cr>",
          ["<ESC>"] = "<cmd>wincmd p<cr>",
        },
      },
    },
  },
  {
    "stevearc/resession.nvim",
    config = function(_, opts)
      local resession = require("resession")
      resession.setup(opts)
      resession.add_hook("pre_load", function()
        if resession.get_current() then
          resession.save(resession.get_current())
        end
        local overseer = require("overseer")
        for _, task in pairs(overseer.list_tasks()) do
          task:dispose(true)
        end
      end)
      resession.add_hook("post_load", function()
        local ok, neogit = pcall(require, "neogit")
        if ok then
          neogit.dispatch_reset()
        end
      end)
    end,
    opts = {
      autosave = {
        enabled = true,
        interval = 300,
        notify = true,
      },
      extensions = {
        overseer = {
          unique = true,
        },
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    opts = true,
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup()
    end,
  },

  -- {
  --   "ecthelionvi/NeoComposer.nvim",
  --   dependencies = { "kkharji/sqlite.lua" },
  --   opts = {},
  -- },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      { "tsakirist/telescope-lazy.nvim" },
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        config = function()
          require("telescope").load_extension("smart_open")
          local config = require("smart-open").config
          config.match_algorithm = "fzf"
          config.show_scores = true
        end,
        dependencies = {
          "kkharji/sqlite.lua",
        },
      },
    },
    opts = function(spec, opts)
      opts.defaults.dynamic_preview_title = true
      return opts
    end,
    keys = function(_, keys)
      keys[#keys + 1] = { "<leader>sl", "<cmd>Telescope lazy<cr>", desc = "Lazy Plugins" }
      return keys
    end,
  },
  {
    dir = "~/git/telescope-all-recent.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "kkharji/sqlite.lua", "stevearc/dressing.nvim" },
    opts = {
      -- debug = true,
      pickers = {
        ["lazy#lazy"] = {
          disable = false,
          use_cwd = false,
        },
      },
      vim_ui_select = {
        kinds = {
          overseer_template = {
            use_cwd = true,
            prompt = "Task template",
            name_include_prompt = true,
          },
          overseer_task_options = {
            use_cwd = true,
            name_include_prompt = true,
          },
          resession_load = {
            use_cwd = false,
          },
        },
        -- only fallback, if no kind exists or is found
        prompts = {
          ["Load session"] = {
            use_cwd = false,
          },
        },
      },
    },
  },
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   dependencies = { "kkharji/sqlite.lua" },
  --   config = function()
  --     require("telescope").load_extension("frecency")
  --   end,
  -- },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      require("ufo").setup({
        fold_virt_text_handler = function(text, lnum, endLnum, width)
          -- local suffix = "  "
          local suffix = " >>"
          local lines = ("(%d lines) "):format(endLnum - lnum)

          local cur_width = 0
          for _, section in ipairs(text) do
            cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
          end

          suffix = suffix .. (" "):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

          table.insert(text, { suffix, "Comment" })
          table.insert(text, { lines, "Todo" })
          return text
        end,
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("bqf").setup({
        func_map = {
          pscrollup = "<C-u>",
          pscrolldown = "<C-d>",
          ptogglemode = "P",
          ptoggleauto = "p",
          ptoggleitem = "zp",
        },
      })
      local start_telescope = function()
        vim.cmd("cclose")
        require("telescope.builtin").quickfix()
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<C-t>",
            "<cmd>lua _G.xonuto.start_telescope_qf()<cr>",
            { nowait = true, noremap = true }
          )
          vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<cmd>wincmd p<cr>", { nowait = true, noremap = true })
          -- -- let treesitter use bash highlight for zsh files as well
          -- require("nvim-treesitter.highlight").attach(0, "bash")
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      disable_commit_confirmation = true,
      integrations = {
        telescope = true,
      },
    },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = false,
    config = function()
      require("lsp_lines").setup()
      require("lsp_lines").toggle()

      -- vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
    end,
  },
  { "anuvyklack/hydra.nvim" },

  {
    "notomo/gesture.nvim",
    config = function()
      vim.keymap.set("n", "<M-LeftMouse>", "<LeftMouse>", { silent = true })
      vim.keymap.set("n", "<M-LeftDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
      vim.keymap.set("n", "<M-LeftRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })
      local gesture = require("gesture")
      gesture.register({
        name = "scroll to top",
        inputs = { gesture.up(), gesture.down() },
        action = "normal! gg",
      })
      gesture.register({
        name = "scroll to bottom",
        inputs = { gesture.down(), gesture.up() },
        action = "normal! G",
      })
      gesture.register({
        name = "File tree",
        inputs = { gesture.left() },
        action = "Neotree toggle",
      })
      gesture.register({
        name = "Close window",
        inputs = { gesture.right(), gesture.left() },
        action = "hide",
      })
      gesture.register({
        name = "Close window",
        inputs = { gesture.left(), gesture.right() },
        action = "hide",
      })
      gesture.register({
        name = "quickfix",
        inputs = { gesture.down() },
        action = function()
          local winnr = vim.fn.winnr("$")
          vim.cmd([[cclose]])
          if winnr == vim.fn.winnr("$") then
            vim.cmd([[copen]])
          end
        end,
      })
      gesture.register({
        name = "vsplit",
        inputs = { gesture.right() },
        action = "vsplit",
      })
      gesture.register({
        name = "split",
        inputs = { gesture.up() },
        action = "split",
      })
    end,
  },

  {
    "atusy/telescomp",
    config = function()
      local cmdline_builtin = require("telescomp.cmdline.builtin")
      -- complete with `getcompletion`
      vim.keymap.set("c", "<C-Space>", function()
        _G.mycmdcmp()
      end)
      vim.keymap.set("c", "<C-X><C-X>", function()
        _G.mycmdcmp()
      end)
    end,
  },
  {
    "edluffy/hologram.nvim",
    config = function()
      -- require("hologram").setup({
      --   auto_display = true,
      -- })
    end,
  },
}