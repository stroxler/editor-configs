vim.g.mapleader = " "

---- File explorer ----
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex, { desc = "Open file explorer (netrw)" })

---- Diagnostics toggle ----
local virtual_text = true
vim.keymap.set("n", "<leader>td", function()
  virtual_text = not virtual_text
  vim.diagnostic.config({ virtual_text = virtual_text })
end, { desc = "Toggle diagnostics" })

---- Window navigation ----
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Window prefix" })
vim.keymap.set("n", "<leader>wd", "<cmd>close<cr>", { desc = "Delete window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close other windows" })

vim.keymap.set("n", "<C-w><Up>", "<C-w>k", { desc = "Move to window above" })
vim.keymap.set("n", "<C-w><Down>", "<C-w>j", { desc = "Move to window below" })
vim.keymap.set("n", "<C-w><Left>", "<C-w>h", { desc = "Move to window left" })
vim.keymap.set("n", "<C-w><Right>", "<C-w>l", { desc = "Move to window right" })
vim.keymap.set("t", "<C-w><Up>", "<C-\\><C-n><C-w>k", { desc = "Move to window above (terminal)" })
vim.keymap.set("t", "<C-w><Down>", "<C-\\><C-n><C-w>j", { desc = "Move to window below (terminal)" })
vim.keymap.set("t", "<C-w><Left>", "<C-\\><C-n><C-w>h", { desc = "Move to window left (terminal)" })
vim.keymap.set("t", "<C-w><Right>", "<C-\\><C-n><C-w>l", { desc = "Move to window right (terminal)" })

---- Leader from insert/terminal mode ----
local function leader_from_mode()
  local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false)
  local space = vim.api.nvim_replace_termcodes("<Space>", true, false, true)
  vim.api.nvim_feedkeys(space, "m", false)
end
vim.keymap.set("i", "<M-Space>", leader_from_mode, { desc = "Leader from insert mode" })
vim.keymap.set("t", "<M-Space>", leader_from_mode, { desc = "Leader from terminal mode" })
vim.keymap.set("i", "<C-Space>", leader_from_mode, { desc = "Leader from insert mode" })
vim.keymap.set("t", "<C-Space>", leader_from_mode, { desc = "Leader from terminal mode" })
vim.keymap.set("n", "<C-Space>", "<Space>", { remap = true, desc = "Leader from normal mode" })

---- Buffers ----
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>bk", "<cmd>bdelete<cr>", { desc = "Kill buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>", { desc = "Switch to last buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bs", "<cmd>write<cr>", { desc = "Save buffer" })

---- Multi-line insert in Visual Line mode ----
vim.keymap.set("x", "I", function()
  if vim.fn.mode() == "V" then
    return "<C-v>I"
  end
  return "I"
end, { expr = true, desc = "Multi-line insert at start" })

vim.keymap.set("x", "A", function()
  if vim.fn.mode() == "V" then
    return "<C-v>$A"
  end
  return "A"
end, { expr = true, desc = "Multi-line append at end" })
