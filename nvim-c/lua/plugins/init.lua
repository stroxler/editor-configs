return {
  ---- Colorschemes ----
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  { "sainnhe/everforest" },
  { "morhetz/gruvbox" },
  { "romainl/apprentice" },
  { "nordtheme/vim" },
  { "phha/zenburn.nvim" },
  { "tsax/stellarized" },

  ---- Utilities ----
  { "nvim-lua/plenary.nvim" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>f", group = "find" },
        { "<leader>c", group = "claude (continue/verbose)" },
        { "<leader>d", group = "claude code" },
        { "<leader>w", group = "window" },
      },
    },
  },

  ---- Status line ----
  {
    "nvim-lualine/lualine.nvim",
    opts = {},
  },

  ---- Code manipulation ----
  { "numToStr/Comment.nvim" },
  { "wellle/targets.vim" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mg979/vim-visual-multi" },

  ---- Treesitter ----
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install("all")
      local ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok and parsers.ft_to_lang == nil and vim.treesitter.language.get_lang ~= nil then
        parsers.ft_to_lang = vim.treesitter.language.get_lang
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  ---- Fuzzy finder ----
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").load_extension("fzf")
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fl", function()
        require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
      end, desc = "Find files (local to current file)" },
    },
  },

  ---- Autocomplete ----
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  ---- Git ----
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  ---- TLA+ ----
  {
    "susliko/tla.nvim",
    config = function()
      require("tla").setup()
    end,
  },

  ---- Claude Code ----
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.env.CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION = "false"
      local function resolve_agent_command()
        local env_agent = vim.env.AGENT_COMMAND or os.getenv("AGENT_COMMAND")
        if env_agent and vim.trim(env_agent) ~= "" then
          return env_agent
        end
        return "claude"
      end

      local function is_codex_command(command)
        local trimmed = vim.trim(command)
        return trimmed == "codex" or vim.startswith(trimmed, "codex ")
      end

      local function resolve_command_variants(command)
        if is_codex_command(command) then
          return {
            continue = "resume --last",
            resume = "resume",
            verbose = "--verbose",
          }
        end
        return {
          continue = "--continue",
          resume = "--resume",
          verbose = "--verbose",
        }
      end

      local agent_command = resolve_agent_command()

      local claude = require("claude-code")
      claude.setup({
        window = {
          split_ratio = 0.3,
          position = "vertical",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },
        refresh = {
          enable = true,
          updatetime = 100,
          timer_interval = 1000,
          show_notifications = true,
        },
        git = { use_git_root = true },
        command = agent_command,
        command_variants = resolve_command_variants(agent_command),
        keymaps = {
          toggle = {
            normal = "<C-,>",
            terminal = "<C-,>",
            variants = {
              continue = "<leader>dc",
              resume = "<leader>dr",
              verbose = "<leader>cV",
            },
          },
          window_navigation = false,
          scrolling = true,
        },
      })

      local original_toggle = claude.toggle
      claude.toggle = function(...)
        local command = resolve_agent_command()
        claude.config.command = command
        claude.config.command_variants = resolve_command_variants(command)
        return original_toggle(...)
      end

      local original_toggle_with_variant = claude.toggle_with_variant
      claude.toggle_with_variant = function(variant_name)
        local command = resolve_agent_command()
        claude.config.command = command
        claude.config.command_variants = resolve_command_variants(command)
        return original_toggle_with_variant(variant_name)
      end
    end,
  },
}
