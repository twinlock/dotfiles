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
		"echasnovski/mini.animate",
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
	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"saifulapm/neotree-file-nesting-config", -- add plugin as dependency. no need any other config or setup call
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			-- recommanded config for better UI
			hide_root_node = true,
			retain_hidden_root_indent = true,
			filesystem = {
				filtered_items = {
					show_hidden_count = false,
					never_show = {
						".DS_Store",
					},
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
				},
			},
			-- explicitly configure sources so we can one day see document symbols
			sources = {
				"filesystem",
				"buffers",
				"git_status",
				"document_symbols",
			},
			-- others config
		},
		config = function(_, opts)
			-- Adding rules from plugin
			opts.nesting_rules = require("neotree-file-nesting-config").nesting_rules
			require("neo-tree").setup(opts)
		end,
	},
}
