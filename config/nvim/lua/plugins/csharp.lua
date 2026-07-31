-- C# for Unity: roslyn.nvim runs the official Roslyn language server
-- (same engine as VS Code's C# extension, none of the Dev Kit licensing nonsense).
-- LazyVim's lang.dotnet extra still uses the discontinued omnisharp, so we go direct.
return {
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		init = function()
			-- the roslyn LS needs a newer .NET runtime than the distro ships;
			-- point just the LS process at the user-local install (~/.dotnet)
			local dotnet_root = vim.fn.expand("~/.dotnet")
			vim.lsp.config("roslyn", {
				-- the LS needs a newer .NET than the distro ships; use ~/.dotnet if present
				cmd_env = vim.uv.fs_stat(dotnet_root) and { DOTNET_ROOT = dotnet_root } or nil,
				-- keep analysis scoped to open files: fullSolution on a 130-project
				-- unity solution floods nvim's core with diagnostics and hangs
				-- :w/:qa. cross-file freshness comes from the BufWritePost re-pull
				-- in config/autocmds.lua instead
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
				},
			})
		end,
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- find the Unity-generated .sln even when nvim is opened from a parent dir
			broad_search = true,
			-- Unity regenerates project files constantly; let roslyn do its own
			-- file watching instead of flooding nvim's watcher
			filewatching = "roslyn",
			-- stick with the solution it attaches to (switch manually with :Roslyn target)
			lock_target = true,
			-- unity projects aren't git repos, so discovery can wander into sibling
			-- projects; pick the sln whose folder is a unity project root above this file
			choose_target = function(targets)
				local bufname = vim.api.nvim_buf_get_name(0)
				return vim.iter(targets):find(function(target)
					local dir = vim.fs.dirname(target)
					return vim.uv.fs_stat(dir .. "/ProjectSettings") ~= nil
						and vim.startswith(bufname, dir .. "/")
				end)
			end,
		},
	},
	-- the roslyn LS binary lives in a community mason registry
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
			ensure_installed = { "roslyn" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "c_sharp" } },
	},
}
