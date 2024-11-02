local telescope = require('telescope')
local builtin = require('telescope.builtin')
-- require'telescope'.load_extension('project')
require('telescope').load_extension('changed_files')
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
local lga_actions = require("telescope-live-grep-args.actions")

local pickers = require("telescope.pickers") 
local finders = require("telescope.finders") 
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local actions = require('telescope.actions')
local actions_set = require('telescope.actions.set')
local from_entry = require('telescope.from_entry')
local actions_state = require('telescope.actions.state')

-- vim.cmd([[
-- 	highlight link TelescopePromptTitle PMenuSel
-- 	highlight link TelescopePreviewTitle PMenuSel
-- 	highlight link TelescopePromptNormal NormalFloat
-- 	highlight link TelescopePromptBorder FloatBorder
-- 	highlight link TelescopeNormal CursorLine
-- 	highlight link TelescopeBorder CursorLineBg
-- ]])

-- require('telescope').setup({
telescope.setup({
	defaults = {
		layout_config = {
			prompt_position = 'top',
		},
		prompt_prefix = '  ',
		sorting_strategy = 'ascending',
		mappings = {
			i = {
				['<esc>'] = actions.close,
			}
		},
		file_ignore_patterns = { '.git/' },
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		buffers = {
			previewer = false,
			layout_config = {
				width = 80,
			},
		},
		oldfiles = {
			prompt_title = 'History',
		},
		lsp_references = {
			previewer = false,
		},
	},
	extensions = {
		live_grep_args = {
			auto_quoting = false, -- enable/disable auto-quoting
			-- define mappings, e.g.
			mappings = { -- extend mappings
				i = {
					-- ["<C-k>"] = lga_actions.quote_prompt(),
					["<C-k>"] = lga_actions.quote_prompt({ postfix = " --glob *." }),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					-- freeze the current list and start a fuzzy search in the frozen list
					-- ["<C-space>"] = actions.to_fuzzy_refine,
				},
			},
		},
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
	},
})
-- require('telescope').load_extension('fzf')
telescope.load_extension("live_grep_args")
telescope.load_extension('fzf')

-- helper to search in config folder
function Vimfiles()
	-- folder of different system
	-- local folder = "~/.config/nvim-prime"
	-- if package.config:sub(1,1) == '\\' then
		-- folder =  "~/Appdata/Local/nvim-prime"
		folder =  "~/.config/nvim"
	-- end
	local opts = {
		cwd = folder,
		follow = true,
	--	file_ignore_patterns = {'.git'},
	--	previewer = false,
		-- try to not show the whole path because I don't need it: none of below seems to work...
	--	shorten_path = true,
		-- path_display = {"smart"},
	}
	builtin.find_files(opts)
end

function findTeleScopeEntries()
	utils.get_os_command_output(cmd)
end

local cdPicker = function(name, cmd)
    pickers.new({}, {
        prompt_title = name,
        finder = finders.new_table{
					results = utils.get_os_command_output(cmd)
				},
        previewer = previewers.vim_buffer_cat.new({}),
        sorter = sorters.get_fuzzy_file(),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function(_, type)
                local entry = actions_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local dir = from_entry.path(entry)
                vim.cmd('cd '..dir)
								vim.cmd('LspStop')
								vim.cmd('echo "lsp stopped."')
            end)
            return true
        end,
    }):find()
end

function Cd(path)
    path = path or '.'
    cdPicker(path, {"fd", ".", path, "--type=d", "--max-depth=1"})
end

function Cdz()
    cdPicker('z directories', {vim.o.shell, '-c', "cat ~/.z | cut -d '|' -f1"})
end


-- [e]dit [e]nvironment
vim.keymap.set("n","<leader>ee", ":lua Vimfiles()<CR>", {noremap=true, silent=true})


-- [b]uffer [s]ymbols: list file symbols with treesitter

-- [w]orkspace [symbols] using lsp
-- vim.keymap.set('n', '<leader>ws', function()
-- 	local q=vim.fn.input("Symbol partial name > ")
-- 	builtin.lsp_workspace_symbols({query=q})
-- end, {noremap=true})

function TelescopeFindFilesCustom()
	local opts = {
		previewer = false,
	}
	builtin.find_files(opts)
end

-- [f]ind [f]ile
vim.keymap.set('n', '<leader>f', TelescopeFindFilesCustom, {noremap=true})
-- [d]iagnostic [w]orkspace
vim.keymap.set('n', '<leader>dw', builtin.diagnostics, {noremap=true})
-- [g]rep
vim.keymap.set('n', '<leader>g', function() require("telescope").extensions.live_grep_args.live_grep_args({ previewer = false, }) end, { noremap = true })
-- sy[m]bols
-- vim.keymap.set('n', '<leader>m', builtin.symbols, {noremap=true})
-- vim.keymap.set('n', '<leader>m', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { noremap = true, silent = true })

-- grep [c]ursor [w]ord
vim.keymap.set('n', '<leader>S', live_grep_args_shortcuts.grep_word_under_cursor, {noremap = true})
-- [h]i[s]tory
vim.keymap.set('n', '<leader>hs', builtin.oldfiles, {noremap=true})
-- [o]pen buffer listとか...
vim.keymap.set('n', '<leader>o', builtin.buffers, {noremap=true})
-- [c]olor [s]cheme
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, {noremap=true})
-- open projects
vim.keymap.set('n', '<leader>0', ":lua Cd(os.getenv('WORKSPACE'))<CR>", {noremap = true, silent = true})
-- 
vim.keymap.set('n', '<leader>cf', '<cmd>:Telescope changed_files<CR>', { noremap = true, silent = true })

