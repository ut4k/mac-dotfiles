local dap = require("dap")
require("nvim-dap-virtual-text").setup()

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#PHP
-- vscode-php-debugが必要
dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" },
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "Listen for Xdebug",
		port = 9000,
		log = true,
		pathMappings = {
			["/var/www/html/knowbe-api/"] = "${workspaceFolder}"
		},
	},
}

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<F4>", ":lua require'dapui'.toggle()<CR>", { silent = true })
map("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true })
map("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true })
map("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true })
map("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true })
map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
map("n", "<leader>bc", ":lua require'dap'.clear_breakpoints()<CR>", { silent = true })
map("n", "<Leader>df", ":lua require'dapui'.eval(nil, { enter = true })<CR>", { silent = true })
map("n", "<leader>de", ":lua require'dapui'.elements.watches.add(vim.fn.expand('<cword>'))<CR>", { silent = true })
map("n", "<leader><leader>df", ":lua require'dapui'.eval()<CR>", { silent = true })

require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	-- Expand lines larger than the window
	-- Requires >= 0.7
	expand_lines = vim.fn.has("nvim-0.7") == 1,
	-- Layouts define sections of the screen to place windows.
	-- The position can be "left", "right", "top" or "bottom".
	-- The size specifies the height/width depending on position. It can be an Int
	-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
	-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
	-- Elements are the elements shown in the layout (in order).
	-- Layouts are opened in order so that earlier layouts take priority in window sizing.
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40, -- 40 columns
			position = "left",
		},
		{
			elements = {
				"repl",
			},
			-- size = 0.25, -- 25% of total lines
			size = 0.10, -- 25% of total lines
			position = "bottom",
		},
	},
	controls = {
		-- Requires Neovim nightly (or 0.8 when released)
		enabled = true,
		-- Display controls in this element
		element = "repl",
		icons = {
			pause = "",
			play = "",
			step_into = "",
			step_over = "",
			step_out = "",
			step_back = "",
			-- run_last = "↻",
			terminate = "□",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil, -- Can be integer or nil.
		max_value_lines = 100, -- Can be integer or nil.
	},
})
