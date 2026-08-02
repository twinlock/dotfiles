-- Autocmds loaded automatically by LazyVim (deferred, shortly after startup).

-- Unity integration: com.walcht.ide.neovim sends open-at-line requests to the
-- nvim instance listening on /tmp/nvimsocket. Only claim the socket when this
-- nvim was started inside a Unity project, so a random nvim elsewhere doesn't
-- steal Unity's opens. Runs directly at load time: LazyVim loads this file
-- after VimEnter, so a VimEnter autocmd would never fire.
local function claim_unity_socket()
	local socket = "/tmp/nvimsocket"
	if vim.uv.fs_stat(vim.fn.getcwd() .. "/ProjectSettings") == nil then
		return
	end
	-- clean up a stale socket from a crashed session, but leave a live one alone
	if vim.uv.fs_stat(socket) then
		local ok, chan = pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true })
		if ok and chan > 0 then
			vim.fn.chanclose(chan)
			return -- another Unity nvim is already listening
		end
		vim.uv.fs_unlink(socket)
	end
	pcall(vim.fn.serverstart, socket)
	-- title the terminal window "nvimunity" so Unity's wmctrl focus call finds it
	vim.o.title = true
	vim.o.titlestring = "nvimunity"
end

claim_unity_socket()

-- C#: don't format on save. Roslyn formatting on a busy Unity solution can
-- stall :w for seconds, and auto-reformatting Unity code is unwanted anyway.
-- Format explicitly with <leader>cf when desired.
-- Also indent with 4 spaces (C#/Unity convention) instead of the global 2.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function(ev)
		vim.b[ev.buf].autoformat = false
		vim.bo[ev.buf].expandtab = true
		vim.bo[ev.buf].shiftwidth = 4
		vim.bo[ev.buf].softtabstop = 4
		vim.bo[ev.buf].tabstop = 4
	end,
})

-- Repos with no committed formatter config: never format on save there.
-- Manual <leader>cf still works.
local no_autoformat_roots = {
	vim.fn.expand("~/Development/Apps/stellr-gamepad"),
	vim.fn.expand("~/Development/Apps/mythic-scribe"),
}
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("project_no_autoformat", { clear = true }),
	callback = function(ev)
		local file = vim.api.nvim_buf_get_name(ev.buf)
		for _, root in ipairs(no_autoformat_roots) do
			if file == root or vim.startswith(file, root .. "/") then
				vim.b[ev.buf].autoformat = false
				return
			end
		end
	end,
})

-- C#: after a save, re-pull diagnostics for the other open buffers so e.g. a
-- class rename shows breakage elsewhere without needing :e. This is the cheap
-- alternative to roslyn's fullSolution analysis scope (see plugins/csharp.lua).
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.cs",
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients({ name = "roslyn" })) do
			pcall(vim.lsp.handlers["workspace/diagnostic/refresh"], nil, nil, {
				client_id = client.id,
				method = "workspace/diagnostic/refresh",
			})
		end
	end,
})
