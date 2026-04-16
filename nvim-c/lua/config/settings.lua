vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.signcolumn = 'yes'

-- Mouse: off by default, toggle with :set mouse=a / :set mouse=
vim.opt.mouse = ''

-- Default indentation (per-filetype overrides via ftplugin or autocmds)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.termguicolors = true

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30

-- TLA+ filetype detection
vim.filetype.add({
  extension = {
    tla = "tlaplus",
    cfg = "tlaplus",
  }
})

-- TLA+ conceal: show unicode symbols for ASCII operators
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tlaplus",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = ""
  end,
})
