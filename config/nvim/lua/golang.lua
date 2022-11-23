local M = {}


local dap = require("dap")

M.setup_adapter = function ()
	dap.adapters.go = function(callback, config)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = {nil, stdout},
			args = {"dap", "-l", "127.0.0.1:" .. port},
			detached = true
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				print('dlv exited with code', code)
			end
		end)
		assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require('dap.repl').append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(
		function()
			callback({type = "server", host = "127.0.0.1", port = port})
		end,
		100)
	end
end

M.default_dap_config = function()
	return
	{
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "./${relativeFileDirname}"
		},
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}"
		}
	}

end
M.setup_configs = function ()
	dap.configurations.go = M.default_dap_config()
end

M.closest_test = function ()
end

M.debug_test = function()
	local test_name
	local cword = vim.fn.expand('<cword>')
	if string.match(cword, "Test") then
		test_name = cword
	else
		test_name = vim.fn.input("Test name to debug: ")
	end
	local test_conf = {
			type = "go",
			mode = "test",
			request = "launch",
			name = "Debug a test",
			program = './' .. "${relativeFileDirname}",
			args = {'-test.run', '^' .. test_name}
	}
	dap.configurations.go = { test_conf }
	dap.set_breakpoint()
	dap.continue()

	-- restore default debug configuration
	dap.configurations.go = M.default_dap_config()
end

M.setup = function()
	if vim.fn.exists("GoDebugTest") == 0 then
		vim.cmd( [[command! GoDebugTest :lua require('golang').debug_test() ]] )
	end
	M.setup_adapter()
	M.setup_configs()
end


return M
