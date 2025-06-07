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
local conf = require('telescope.config').values

-- vim.cmd([[
-- 	highlight link TelescopePromptTitle PMenuSel
-- 	highlight link TelescopePreviewTitle PMenuSel
-- 	highlight link TelescopePromptNormal NormalFloat
-- 	highlight link TelescopePromptBorder FloatBorder
-- 	highlight link TelescopeNormal CursorLine
-- 	highlight link TelescopeBorder CursorLineBg
-- ]])

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
				-- 行頭にカーソルを移動
        ["<C-a>"] = function()
          vim.api.nvim_win_set_cursor(0, {1, 0})
        end,
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
-- vim.keymap.set('n', '<leader>g', function() require("telescope").extensions.live_grep_args.live_grep_args({ previewer = false, }) end, { noremap = true })

-- >>>
local regex_mode = false

local function toggle_regex(prompt_bufnr)
  regex_mode = not regex_mode
  local current_input = require("telescope.actions.state").get_current_line()
  local actions = require("telescope.actions")
  actions.close(prompt_bufnr)

  require("telescope").extensions.live_grep_args.live_grep_args({
    default_text = current_input,
    prompt_title = regex_mode and "Live Grep (RegEx)" or "Live Grep (Fixed)",
    previewer = false,
    additional_args = function()
      if not regex_mode then
        return { "--fixed-strings" }
      end
      return {}
    end,
    mappings = {
      i = { ["<C-r>"] = toggle_regex },
      n = { ["<C-r>"] = toggle_regex },
    },
  })
end

vim.keymap.set('n', '<leader>g', function()
  require("telescope").extensions.live_grep_args.live_grep_args({
    prompt_title = regex_mode and "Live Grep (RegEx)" or "Live Grep (Fixed)",
    previewer = false,
    additional_args = function()
      if not regex_mode then
        return { "--fixed-strings" }
      end
      return {}
    end,
    mappings = {
      i = { ["<C-r>"] = toggle_regex },
      n = { ["<C-r>"] = toggle_regex },
    },
  })
end, { noremap = true })
-- <<<

-- [G]rep function
vim.keymap.set('n', '<leader>G', function() require("telescope").extensions.live_grep_args.live_grep_args({
  previewer = false,
  default_text = "function.*",
}) end, { noremap = true })
-- sy[m]bols
-- vim.keymap.set('n', '<leader>m', builtin.symbols, {noremap=true})
-- vim.keymap.set('n', '<leader>m', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>m', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })

-- grep [c]ursor [w]ord
vim.keymap.set('n', '<leader>S', live_grep_args_shortcuts.grep_word_under_cursor, {noremap = true})
-- [o]pen buffer listとか...
vim.keymap.set('n', '<leader>o', builtin.buffers, {noremap=true})
-- [c]olor [s]cheme
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, {noremap=true})
-- open projects
vim.keymap.set('n', '<leader>0', ":lua Cd(os.getenv('WORKSPACE'))<CR>", {noremap = true, silent = true})
-- 
vim.keymap.set('n', '<leader>cf', '<cmd>:Telescope changed_files<CR>', { noremap = true, silent = true })

local function oldfiles_cwd()
  local cwd = vim.loop.cwd() -- or vim.fn.getcwd()
  local results = {}

  for _, file in ipairs(vim.v.oldfiles) do
    if vim.loop.fs_stat(file) and file:sub(1, #cwd) == cwd then
      table.insert(results, file)
    end
  end

  pickers.new({}, {
    prompt_title = "Oldfiles (cwd)",
    finder = finders.new_table {
      results = results,
    },
    sorter = conf.file_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function()
        actions.close()
        local selection = actions_state.get_selected_entry()
        vim.cmd("edit " .. selection[1])
      end)
      return true
    end,
  }):find()
end
-- [h]i[s]tory
-- すべてのoldfilesにアクセス
-- vim.keymap.set('n', '<leader>hs', builtin.oldfiles, {noremap=true})
-- cwd以下ののoldfilesにアクセス
-- vim.keymap.set('n', '<leader>hs', oldfiles_cwd, { noremap = true, silent = true })
--
local function oldfiles_relative_to_cwd()
  local cwd = vim.loop.cwd()
  local results = {}

  for _, file in ipairs(vim.v.oldfiles) do
    if vim.loop.fs_stat(file) and file:sub(1, #cwd) == cwd then
      local relative = file:sub(#cwd + 2)
      table.insert(results, { path = file, display = relative })
    end
  end

  pickers.new({}, {
    prompt_title = "Oldfiles (relative paths)",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry.path,
          display = entry.display,
          ordinal = entry.display,
        }
      end,
    },
    sorter = sorters.get_fuzzy_file(),
    previewer = previewers.cat.new({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
        end
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<leader>hs', oldfiles_relative_to_cwd, { noremap = true, silent = true })


-- DataProviderにジャンプ(Laravel)
local function list_data_providers()
  local file = vim.fn.expand("%") -- 現在のファイル
  local providers = {}
  local seen = {}

  -- @dataProvider 行から関数名を抽出
  for _, line in ipairs(vim.fn.readfile(file)) do
    local match = line:match("@dataProvider%s+([a-zA-Z0-9_]+)")
    if match and not seen[match] then
      table.insert(providers, match)
      seen[match] = true
    end
  end

  pickers.new({}, {
    prompt_title = "@dataProvider jump with preview",
    finder = finders.new_table {
      results = providers,
      entry_maker = function(entry)
        return {
          value = entry,
          display = "󰊕 " .. entry,
          ordinal = entry,
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = previewers.new_buffer_previewer {
      define_preview = function(self, entry)
        local pattern = "function.*" .. entry.value
        local cmd = string.format("grep -n '%s' %s", pattern, vim.fn.shellescape(file))
        local result = vim.fn.systemlist(cmd)
        if #result == 0 then
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "関数が見つかりませんでした。" })
          return
        end

        local line_info = result[1]
        local lnum = tonumber(line_info:match("^(%d+):"))
        if not lnum then
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "行番号の解析に失敗しました。" })
          return
        end

        -- 関数周辺を表示（-5〜+15行）
        local start = math.max(lnum - 5, 1)
        local end_ = lnum + 15
        local lines = vim.fn.readfile(file, "", end_)
        local preview_lines = {}
        for i = start, math.min(end_, #lines) do
          table.insert(preview_lines, lines[i])
        end
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
      end
    },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not selection then return end

        local pattern = "function.*" .. selection.value
        local cmd = string.format("grep -n '%s' %s", pattern, vim.fn.shellescape(file))
        local result = vim.fn.systemlist(cmd)

        if #result == 0 then
          print("関数 " .. selection.value .. " が見つかりませんでした。")
          return
        end

        local line = result[1]
        local lnum = tonumber(line:match("^(%d+):"))
        if lnum then
          vim.api.nvim_win_set_cursor(0, { lnum, 0 })
          print("Jumped to function: " .. selection.value)
        else
          print("ジャンプ失敗（行番号解析できず）")
        end
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<leader>dp', list_data_providers, { noremap = true, silent = true })


-- -----------------------------------------------
local controller_base_path = "app/Http/Controllers"

local function get_controller_methods()
  local results = {}
  local handle = io.popen('rg "function " ' .. controller_base_path .. ' --glob "*.php" --line-number')
  if handle then
    for line in handle:lines() do
      -- ファイルパス、行番号、関数名を抽出
      local filepath, lineno, func = string.match(line, "([^:]+):(%d+):.*function%s+([%w_]+)")
      if filepath and lineno and func then
        -- クラス名をApp名前空間スタイルに変換
        local class_path = filepath
          :gsub("^app/", "App/")
          :gsub("%.php$", "")
          :gsub("/", "\\")
        table.insert(results, {
          display = class_path .. "@" .. func,
          path = filepath,
          line = tonumber(lineno),
        })
      end
    end
    handle:close()
  end
  return results
end

local function open_controller_method_picker()
  local items = get_controller_methods()

  local entry_maker = function(entry)
    local ord = entry.display
    return {
      value = entry,
      display = entry.display,
      ordinal = ord,
      line = entry.line,
      path = entry.path,
    }
  end

  pickers.new({}, {
    prompt_title = "Laravel Controller@method",
    finder = finders.new_table({
      results = items,
      entry_maker = entry_maker,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = actions_state.get_selected_entry().value
        vim.cmd("edit " .. selection.path)
        vim.api.nvim_win_set_cursor(0, { selection.line, 0 })
      end)
      return true
    end,
  }):find()
end
-- laravel [c]ontroller method
vim.keymap.set("n", "<leader>c", open_controller_method_picker, { noremap = true, desc = "Find Laravel Controller@method" })
