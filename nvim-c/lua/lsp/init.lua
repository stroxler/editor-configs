-- Built-in LSP configuration (neovim 0.11+)
-- Uses vim.lsp.config / vim.lsp.enable instead of nvim-lspconfig plugin

vim.diagnostic.config({ virtual_text = true })

vim.lsp.config.nixd = {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', 'git' },
}
vim.lsp.enable({ 'nixd' })

local python_root_dir_markers = {
  'pyproject.toml',
  'pyrefly_wasm',
  '_qualifiers_final_decorator.pyi',
}
vim.lsp.config.pyrefly = {
  cmd = { 'pyrefly', 'lsp' },
  root_markers = python_root_dir_markers,
  filetypes = { 'python' },
}
vim.lsp.enable({ 'pyrefly' })
