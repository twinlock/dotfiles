-- Unity debugging. nvim-dap drives vstuc, the debug adapter Microsoft ships inside
-- its VS Code Unity extension: it speaks Mono's soft-debugger protocol, which is
-- what the Unity Editor actually exposes. netcoredbg is not an option - it only
-- attaches to CoreCLR - and Unity's own vscode-unity-debug was deprecated in 2021.
--
-- The adapter isn't redistributable, so it isn't vendored here; `vstuc-install`
-- (bin/vstuc-install) pulls it into stdpath("data")/vstuc.
--
-- Unity side: Preferences > External Tools > "Editor Attaching" must be on, and the
-- bug icon in the status bar has to read "Debug" (click it to switch out of Release,
-- otherwise the JIT optimises locals away and breakpoints land in the wrong place).

local VSTUC_BIN = vim.fs.joinpath(vim.fn.stdpath("data"), "vstuc", "bin")

-- vstuc 1.3 targets net10.0. The distro's dotnet is still on 9, so prefer the
-- user-local install for the same reason roslyn.nvim does (see csharp.lua): test
-- for the host binary, not the directory, since the CLI leaves telemetry sentinels
-- in ~/.dotnet even when no runtime lives there.
local function dotnet_host()
	local user_host = vim.fn.expand("~/.dotnet/dotnet")
	return vim.uv.fs_stat(user_host) and user_host or "dotnet"
end

-- Nearest ancestor holding both marker dirs. Assets/ alone matches plenty of
-- unrelated trees, and ProjectSettings/ alone matches a package repo's test project.
local function unity_root()
	local from = vim.api.nvim_buf_get_name(0)
	if from == "" then
		from = vim.uv.cwd()
	end
	return vim.fs.root(from, function(name, path)
		return name == "ProjectSettings" and vim.uv.fs_stat(vim.fs.joinpath(path, "Assets")) ~= nil
	end)
end

local function require_unity_root()
	local root = unity_root()
	if not root then
		error("not inside a Unity project (no ProjectSettings/ + Assets/ above this buffer)", 0)
	end
	return root
end

-- Unity's mono debugger listens on 56000 + (editor pid % 1000), and the editor
-- records its own pid in Library/EditorInstance.json - that pairing is how the IDE
-- integrations find the right instance. Scanning listening ports instead (what most
-- of the nvim guides do) also turns up the asset import workers, which sit in the
-- same port range and are never what you want to attach to.
local function unity_endpoint()
	local root = require_unity_root()
	local instance = vim.fs.joinpath(root, "Library", "EditorInstance.json")

	local ok, content = pcall(vim.fn.readfile, instance)
	if not ok then
		error("no Library/EditorInstance.json in " .. root .. " - is the editor open on this project?", 0)
	end

	local decoded_ok, decoded = pcall(vim.json.decode, table.concat(content, "\n"))
	local pid = decoded_ok and type(decoded) == "table" and tonumber(decoded.process_id)
	if not pid then
		error("could not read process_id from " .. instance, 0)
	end

	-- the file outlives the editor process, so confirm that pid is still around
	-- rather than dialling a port that now belongs to nothing (or to something else)
	local alive_ok, alive = pcall(vim.uv.kill, pid, 0)
	if alive_ok and alive ~= 0 then
		error(("Unity pid %d from EditorInstance.json is gone - reopen the editor"):format(pid), 0)
	end

	return ("127.0.0.1:%d"):format(56000 + pid % 1000)
end

-- the adapter logs its mono conversation here; first stop when an attach succeeds
-- but breakpoints never bind
local LOG_FILE = vim.fs.joinpath(vim.fn.stdpath("log"), "vstuc.log")

local configurations = {
	{
		type = "vstuc",
		request = "attach",
		name = "Attach to Unity Editor",
		logFile = LOG_FILE,
		projectPath = require_unity_root,
		endPoint = unity_endpoint,
	},
	{
		-- players and remote editors: the port is printed to the player log as
		-- "Starting managed debugger on port 56xxx"
		type = "vstuc",
		request = "attach",
		name = "Attach to Unity (enter host:port)",
		logFile = LOG_FILE,
		projectPath = function()
			return unity_root() or vim.uv.cwd()
		end,
		endPoint = function()
			return vim.fn.input("Unity debugger endpoint: ", "127.0.0.1:56")
		end,
	},
}

-- Attaching a second time is the whole problem with this adapter. A session that
-- ended on Unity's side - domain reload after a script compile, entering play mode,
-- the editor being busy - often leaves the adapter process alive and still holding
-- the socket, so nvim-dap still thinks a session is running. <leader>dc then only
-- offers its "Session active, but not stopped at breakpoint" menu, and the usual
-- way out is restarting nvim. Tear any session down first and the re-attach just
-- works; nvim-dap signals the adapter if it won't disconnect politely.
local function unity_attach()
	local dap = require("dap")

	local stale = false
	for _, s in pairs(dap.sessions()) do
		if not s.closed then
			stale = true
		end
	end

	if not stale then
		dap.run(configurations[1])
		return
	end

	local started = false
	local function start()
		if not started then
			started = true
			dap.run(configurations[1])
		end
	end

	vim.notify("closing previous debug session", vim.log.levels.INFO)
	dap.terminate({ all = true, on_done = start })
	-- terminate's own timeout is bounded, but don't strand the attach if the
	-- callback is never reached
	vim.defer_fn(start, 8000)
end

return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		-- stylua: ignore
		keys = {
			{ "<leader>dU", unity_attach, desc = "Attach to Unity" },
		},
		opts = function()
			local dap = require("dap")

			if not vim.uv.fs_stat(vim.fs.joinpath(VSTUC_BIN, "UnityDebugAdapter.dll")) then
				vim.notify("vstuc adapter missing - run `vstuc-install` to fetch it", vim.log.levels.WARN)
				return
			end

			dap.adapters.vstuc = {
				type = "executable",
				command = dotnet_host(),
				args = { vim.fs.joinpath(VSTUC_BIN, "UnityDebugAdapter.dll") },
				options = {
					-- keep the adapter in nvim's process group so a crashed nvim can't
					-- leave one orphaned, still holding Unity's debugger socket open
					detached = false,
					-- the adapter keeps streaming module events long after it has stopped
					-- answering requests; don't sit on a wedged one for the default 3s
					-- before nvim-dap escalates to signals
					disconnect_timeout_sec = 1,
				},
			}

			dap.configurations.cs = dap.configurations.cs or {}
			vim.list_extend(dap.configurations.cs, configurations)

			vim.api.nvim_create_user_command("UnityAttach", unity_attach, {
				desc = "Attach the debugger to the Unity editor, replacing any live session",
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		optional = true,
		opts = {
			element_mappings = {
				-- Stacks only ever registers `open` (o) on a frame and `toggle` (t) on a
				-- thread, so <CR> - which is `expand` everywhere else - does nothing
				-- there. Bind it to open, since jumping to a frame is what you reach for.
				-- `t` is worth knowing too: mono marks most non-project frames "subtle"
				-- and dap-ui hides them until you toggle.
				stacks = { open = { "o", "<CR>" } },
			},
		},
	},
}
