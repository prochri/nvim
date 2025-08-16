local build_cmd ---@type string?
for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    lazy = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
        config = function(plugin)
          LazyVim.on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
                end)
              else
                LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { hidden = true, default_text = line })()
      end

      local function find_command()
        if 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },
      }
    end,
  },
  -- better vim.ui with telescope
  {
    "stevearc/dressing.nvim",
    lazy = false,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
    end,
  },

  ---
  --- my config here
  ---
  ---
  {
    "nvim-telescope/telescope.nvim",
    -- change some options
    opts = function(_, opts)
      local _, actions = pcall(require, "telescope.actions")
      opts.defaults.path_display = { "truncate" }
      opts.defaults.dynamic_preview_title = true
      opts.defaults.cache_picker = opts.defaults.cache_picker or {}
      opts.defaults.cache_picker.num_pickers = 100
      opts.pickers = {}
      opts.pickers.find_files = {}
      opts.pickers.find_files.hidden = false
      opts.pickers.commands = {
        theme = "ivy",
      }
      -- opts.pickers.lsp_definitions = {
      --   theme = "cursor",
      -- }
      -- opts.pickers.lsp_references = {
      --   theme = "cursor",
      -- }
      opts.pickers.buffers = {}
      opts.pickers.buffers.initial_mode = "insert"
      opts.pickers.buffers.mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
          ["dd"] = actions.delete_buffer,
        },
      }
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<PageUp>"] = actions.cycle_history_prev,
          ["<PageDown>"] = actions.cycle_history_next,
          ["<ESC>"] = actions.close,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<PageUp>"] = actions.cycle_history_prev,
          ["<PageDown>"] = actions.cycle_history_next,
        },
      }
      local ok, trouble = pcall(require, "trouble.sources.telescope")
      if ok then
        opts.defaults.mappings.i["<C-t>"] = trouble.open
        opts.defaults.mappings.n["<C-t>"] = trouble.open
      end
      opts.defaults.mappings.i["<D-v>"] = { "<C-r>+", type = "command" }
      local history = require("telescope-picker-history-action")
      opts.defaults.mappings.i["<C-,>"] = history.prev_picker
      opts.defaults.mappings.i["<C-.>"] = history.next_picker
      opts.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      }
      opts.defaults = require("telescope.themes").get_ivy(opts.defaults)
    end,
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
      {
        "fdschmidt93/telescope-egrepify.nvim",
        config = function()
          require("telescope").load_extension("egrepify")
        end,
      },
      {
        "jonarrien/telescope-cmdline.nvim",
      },
    },
    keys = function(_, keys)
      keys[#keys + 1] = { "<leader>sl", "<cmd>Telescope lazy<cr>", desc = "Lazy Plugins" }
      return keys
    end,
  },
  {
    dir = "~/git/telescope-picker-history-action",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = true,
    opts = true,
  },
  {
    dir = "~/git/telescope-all-recent.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim", "kkharji/sqlite.lua" },
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
          codeaction = {
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
  {
    "Sharonex/grape.nvim",
    keys = {
      { "<leader>sg", "<cmd>lua require('grape').live_grape()<cr>", desc = "Fuzzier live grep" },
    },
  },
}
