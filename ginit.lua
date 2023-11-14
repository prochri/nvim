print('hello from ginit')

local guifont = 'Comic Mono'
if string.find(vim.o.guifont, guifont) == nil then
  vim.o.guifont = guifont .. ':h10'
end
vim.g.neovide_transparency = 1
vim.g.neovide_remember_window_size = true
vim.g.neovide_remember_window_position = true
vim.g.neovide_scale_factor = 1
