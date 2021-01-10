require'nvim-treesitter.configs'.setup {
  highlight = {enable = true},
  folding = {enable = true},
  refactor = {
    highlight_definitions = {enable = true},
    highlight_current_scope = {enable = true}
    -- use this for renaming and definition jumping?
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner'
      }
    }
  }
}
-- TOOD check for available TS parser and only then load it
