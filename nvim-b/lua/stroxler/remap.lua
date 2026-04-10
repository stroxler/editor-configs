vim.g.mapleader = " "

-- view the *c*urrent file's *d*irectory
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- *t*oggle *d*iagnostics in the current buffer
local virtual_text = true  -- default is set in lua/lsp/init.lua
vim.keymap.set("n", "<leader>td", function()
  virtual_text = not virtual_text
  vim.diagnostic.config({ virtual_text = virtual_text })
end)
