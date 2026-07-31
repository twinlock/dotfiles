-- This installs most plugins that aren't in their own files (lualine and treesitter)
return {
	-- Surround text and all the fun stuff
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- disable some animations
	{
		"nvim-mini/mini.animate",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.scroll = {
				enable = false,
			}
		end,
	},
	-- telescope, fast file fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},
	-- file explorer: LazyVim's snacks explorer (<leader>e) covers it; the old
	-- custom neo-tree spec caused duplicated sources/symbol trees and is gone
}
