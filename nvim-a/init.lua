-- *** Basic Options ***
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.signcolumn = 'yes'

-- Mouse: off by default
-- - You can toggle it on/off manually with :set mouse="a" / :set mouse=""
-- - I should probably consider a keybinding for this
vim.opt.mouse = ''


-- Python-oriented settings: I need to remember how to make these per-language
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- *** Lazy setup ***

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

-- Hack to try to get tla+ files recognized... tree-sitter should already know the
-- syntax, but I wasn't getting highlighting out-of-the-box.
vim.filetype.add({
  extension = {
    tla = "tlaplus",
    cfg = "tlaplus", -- Optional: if you want TLA+ config files highlighted too
  }
})

-- TLA+ conceal: show unicode symbols for ASCII operators
-- Toggle with :set conceallevel=0 (off) / :set conceallevel=2 (on)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tlaplus",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = ""  -- reveal real text on current line
    end,
})

lazy.setup({
  ---- Theming ----
  {'folke/tokyonight.nvim'},
  ---- Utilities ----
  {'nvim-lua/plenary.nvim'},
  ---- Code manipulation ----
  {'numToStr/Comment.nvim'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'mg979/vim-visual-multi'},  -- maybe prune this?
  ---- Treesitter ----
  {
      'nvim-treesitter/nvim-treesitter',
      build = ":TSUpdate",
      config = function()
          -- This appears to be a no-op if grammars are already installed.
          -- I could potentially separate out one-time setup into a lua script if needed.
          require("nvim-treesitter").install("all");
          vim.api.nvim_create_autocmd("FileType", {
              callback = function()
                  pcall(vim.treesitter.start)
              end,
          })
      end
  },
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  ----- LSP support ----
  {'neovim/nvim-lspconfig'},
  ---- Autocomplete ----
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/cmp-nvim-lsp'},
  -- {'akinsho/toggleterm.nvim'},
  -- File explorer
  -- {'kyazdani42/nvim-tree.lua'},
  ---- Fuzzy finder ----
  -- {'nvim-telescope/telescope.nvim', branch = '0.1.x'},
  -- {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  ---- Git ----
  -- {'lewis6991/gitsigns.nvim'},
  -- {'tpope/vim-fugitive'},
  ---- Snippets ----
  -- {'L3MON4D3/LuaSnip'},
  -- {'rafamadriz/friendly-snippets'},
  ---- TLA+ integration ----
  -- note: for this to work out-of-the-box you need to install java and set JAVA_HOME:
  -- export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"
  {
    "susliko/tla.nvim",
    config = function ()
      require("tla").setup()
    end
  },
  ---- Claude integration ----
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end
  }
})

vim.env.CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION = "false"
local env_agent = os.getenv("NVIM_AGENT_COMMAND")
agent_command = env_agent or "claude"


-- Settings taken directly from the README circa 2026-03-22
require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "vertical",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",        -- Width: number of columns or percentage string
      height = "80%",       -- Height: number of rows or percentage string
      row = "center",       -- Row position: number, "center", or percentage string
      col = "center",       -- Column position: number, "center", or percentage string
      relative = "editor",  -- Relative to: "editor" or "cursor"
      border = "rounded",   -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,           -- Enable file change detection
    updatetime = 100,        -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,   -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true,     -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',        -- Command separator used in shell commands
    pushd_cmd = 'pushd',     -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',       -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = agent_command,
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<C-,>",       -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<C-,>",     -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})

-- *** Colors ***

vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')


-- *** Keybindings ***

---- Space as leader key ----
vim.g.mapleader = ' '

---- Commands ----
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>')




-- Claude Code helper: send code selections to the Claude Code terminal
--
-- Usage:
--   1. Select code visually, then :'<,'>ClaudeSend  - send selection with file context
--   2. :ClaudeSendFile     - insert current file path into Claude Code

-- Find the Claude Code terminal buffer (name starts with "claude-code")
local function find_claude_code_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.fnamemodify(name, ':t'):match("^claude%-code") then
        return bufnr
      end
    end
  end
  return nil
end

-- Send text to the Claude Code terminal
local function send_to_claude_code(text)
  local bufnr = find_claude_code_buffer()
  if not bufnr then
    vim.notify("No Claude Code terminal found. Open one first with :ClaudeCode", vim.log.levels.WARN)
    return
  end
  local chan = vim.api.nvim_buf_get_option(bufnr, 'channel')
  if not chan or chan == 0 then
    vim.notify("Claude Code terminal has no active channel", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_chan_send(chan, text)
end

-- Get visual selection from the current buffer
local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return lines, start_line, end_line
end

-- Send visual selection wrapped with file context to Claude Code
local function send_selection_with_context()
  local file = vim.fn.expand('%:p')
  local ft = vim.bo.filetype
  local lines, start_line, end_line = get_visual_selection()

  local text = '```' .. ft .. ' ' .. file .. ':' .. start_line .. '-' .. end_line .. '\n'
  for _, line in ipairs(lines) do
    text = text .. line .. '\n'
  end
  text = text .. '```\n'

  send_to_claude_code(text)
end

-- Send current file path to Claude Code
local function send_file_path()
  send_to_claude_code('File: `' .. vim.fn.expand('%:p') .. '`\n')
end

-- Commands
vim.api.nvim_create_user_command('ClaudeSend', function()
  send_selection_with_context()
end, { range = true })

vim.api.nvim_create_user_command('ClaudeSendFile', function()
  send_file_path()
end, {})

-- Keybindings (leader + c prefix)
vim.keymap.set('v', '<leader>cs', '<cmd>ClaudeSend<cr>', { desc = 'Send selection to Claude Code' })
vim.keymap.set('n', '<leader>cf', '<cmd>ClaudeSendFile<cr>', { desc = 'Send file path to Claude Code' })


-- Multi-line insert in Visual Line mode with 'I' and 'A'

vim.keymap.set("x", "I", function()
    if vim.fn.mode() == "V" then
        return "<C-v>I"
    end
    return "I"
end, { expr = true, desc = "Multi-line insert at start" })

vim.keymap.set("x", "A", function()
    if vim.fn.mode() == "V" then
        -- $ ensures we go to the end of the longest line in the block
        return "<C-v>$A"
    end
    return "A"
end, { expr = true, desc = "Multi-line append at end" })
