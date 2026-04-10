return {
  -- primary color scheme
  {
    "tsax/stellarized",
		lazy = false, -- load the primary color scheme during startup
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme stellarized]])
		end,
  },
  -- additional color schemes
  {
    "sainnhe/everforest",
  },
  {
    "morhetz/gruvbox",
  },
  {
    "romainl/apprentice",
  },
  {
    "nordtheme/vim",
  },
	{
		"folke/tokyonight.nvim",
	},
  {
    "phha/zenburn.nvim"
  },
  -- nicer looking status line
  {
    "nvim-lualine/lualine.nvim"
  },
}
