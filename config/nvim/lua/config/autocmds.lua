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
