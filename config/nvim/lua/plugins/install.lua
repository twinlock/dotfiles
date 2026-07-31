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
	-- file explorer: LazyVim's snacks explorer (<leader>e) covers it; the old
	-- custom neo-tree spec caused duplicated sources/symbol trees and is gone
}
