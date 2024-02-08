return {
  { import = "lazyvim.plugins.extras.dap.core" },
  -- debugging for neovim
  { import = "lazyvim.plugins.extras.dap.nlua" },
  {
    "mfussenegger/nvim-dap",
    config = function(_spec, opts)
      local launchjs = require("dap.ext.vscode")
      local jsts_frontend = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
      launchjs.type_to_filetypes = {
        lldb = { "rust" },
        firefox = jsts_frontend,
        chrome = jsts_frontend,
        ["pwa-chrome"] = jsts_frontend,
      }
      return opts
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      -- open dap ui in new tab
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      -- Attach DAP UI to DAP events
      dap.listeners.after.event_initialized["dapui_config"] = function()
        prochri.dapui.open_in_tab()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        prochri.dapui.close_tab()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        prochri.dapui.close_tab()
      end
      -- local ok, json5 = pcall(require, "json5")
      -- print("json5 is ok: ", ok)
      -- if ok then
      --   require("dap.ext.vscode").json_decode = json5.parse
      -- end
    end,
    opts = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
      },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
      },
      sidebar = {
        elements = {
          -- You can change the order of elements in the sidebar
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        width = 40,
        position = "left", -- Can be "left" or "right"
      },
      tray = {
        elements = { "repl" },
        height = 10,
        position = "bottom", -- Can be "bottom" or "top"
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
    },
  },
}
