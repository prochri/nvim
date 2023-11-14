local Util = require("lazyvim.util")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(spec, old_opts)
      local lualine_c = old_opts.sections.lualine_c
      local function mypretty_path(self)
        local path = vim.fn.expand("%:p") --[[@as string]]

        if path == "" then
          return ""
        end
        local root = Util.root.get({ normalize = true })
        local cwd = Util.root.cwd()

        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        else
          path = path:sub(#root + 2)
        end
        return path
      end
      lualine_c[#lualine_c] = mypretty_path
      return old_opts
    end,
  },
}
