-- Language/LSP tweaks driven by stellr-gamepad and mythic-scribe.
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- vtsls: never adopt the workspace TypeScript. stellr-gamepad hoists
				-- TS 4.5.5 to the repo root (gamepad-electron's pin), which produces
				-- garbage diagnostics against React 19. Mason's vtsls bundles TS 5.9;
				-- use that everywhere. <leader>cV can still pick a workspace version
				-- per-session.
				vtsls = {
					settings = { vtsls = { autoUseWorkspaceTsdk = false } },
				},
				-- pyright: point at the project-local .venv. Root markers
				-- (requirements.txt) give mythic-scribe's server/ and transcription/
				-- their own clients; each resolves its own .venv.
				pyright = {
					before_init = function(_, config)
						-- mutate config.settings in place: the client already holds a
						-- reference to this table, so replacing it would be a no-op
						local venv_python = (config.root_dir or "") .. "/.venv/bin/python"
						if config.settings and vim.uv.fs_stat(venv_python) then
							config.settings.python = config.settings.python or {}
							config.settings.python.pythonPath = venv_python
						end
					end,
				},
			},
		},
	},
	-- css parser missing; both repos have css files.
	{ "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "css" } } },
}
