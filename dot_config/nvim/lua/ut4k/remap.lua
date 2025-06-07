
-- spacebar as my leader
vim.g.mapleader = " "

-- remove some bindings
vim.keymap.set("n", "Q", "<nop>")

-- esc replacement in insert mode
vim.keymap.set("i","fj", "<esc>")
vim.keymap.set("i","jf", "<esc>")

vim.keymap.set("n","<leader><CR>", ":w<CR>")
-- vim.keymap.set("n","<leader>so", ":so<CR>")

-- toggle highlight search
-- vim.keymap.set("n", "<leader> ", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>l", ":noh<CR>")

-- selection (indent and move)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- window/split switching
vim.keymap.set("n", "<C-h>", "<C-w>h", {remap=false})
vim.keymap.set("n", "<C-j>", "<C-w>j", {remap=false})
vim.keymap.set("n", "<C-k>", "<C-w>k", {remap=false})
vim.keymap.set("n", "<C-l>", "<C-w>l", {remap=false})

-- vim.keymap.set("n", "<leader>fn", ":NeoTreeFocusToggle reveal<CR>", {remap=false})
-- [r]eveal [f]ile
vim.keymap.set("n", "<leader>rf", ":NeoTreeRevealToggle<CR>", {remap=false})

-- closing stuff:
-- buffer
-- vim.keymap.set("n","<leader>bb", ":bp|bd #<CR>")
-- window / frame
vim.keymap.set("n","<leader>ww", ":close<CR>")
-- quickfix window
vim.keymap.set("n","<leader>qq", ":cclose<CR>")
-- バッファを閉じる
vim.keymap.set('n', '<c-q>', ':quit<CR>', {remap=false})

-- resize buffer
-- + buffer size vertically
vim.keymap.set('n', '<s-h>', ':vert resize +15<cr>', {remap=false})
-- - buffer vertically
vim.keymap.set('n', '<s-l>', ':vert resize -15<cr>', {remap=false})

-- save
vim.keymap.set('n', '<leader>s', ':w<cr>', {remap=false})
vim.keymap.set("n", "<leader>w", ":w<CR>", {remap = false})

-- semicolon as a colon
vim.keymap.set('n', ';', ':', {remap=false})
vim.keymap.set('n', ':', ';', {remap=false})
vim.keymap.set('v', ';', ':', {remap=false})
vim.keymap.set('v', ':', ';', {remap=false})

-- vim-easy-align
vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})

vim.keymap.set('n', '[q', ':cprev<cr>', {remap=false})
vim.keymap.set('n', ']q', ':cnext<cr>', {remap=false})

-- vim.keymap.set('n', '[a', ':AerialPrev<cr>', {remap=false})
-- vim.keymap.set('n', ']a', ':AerialNext<cr>', {remap=false})
vim.keymap.set('n', ']q', ':cnext<cr>', {remap=false})

-- レジスタを汚さずブラックホールに送る(連続置換のとき有用）
vim.keymap.set('n', '<leader>x', '"_dd', {remap = false})
vim.keymap.set('x', '<leader>x', '"_dd', {remap = false})

-- マクロ実行はQとする（US配列だと@は連続でおしづらいから）
vim.keymap.set('n', 'Q', '@q', { noremap = true, silent = true })

-- visual selection内だけを検索
vim.keymap.set('x', '/', '<Esc>/\\%V')

local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd
Hydra({
   name = 'Lsp',
   config = {
      invoke_on_body = true,
      hint = {
			   type = 'window',
         position = 'middle',
         border = 'rounded',
      },
   },
   mode = 'n',
   -- body = '<Leader>p',
   body = '<Leader>1',
   heads = {
      { 'i', cmd 'LspInfo', { desc = 'LspInfo'} },
      {
				'r',
				function()
					print("restarting lsp...")
					vim.api.nvim_command('LspStop')
					-- 直後だとうまくいかないので数ms待って再起動
					vim.defer_fn(function()
						vim.api.nvim_command('LspStart')
						print("LSP restarted")
					end, 100)
					-- print("restarted")
				end,
				{ exit = true, desc = 'LspRestart'}
			},
      { '<Esc>', nil, { exit = true, nowait = true } },
   }
})

vim.lsp.get_active_clients()

function SwapImplTest()
	local currentFileName = vim.api.nvim_buf_get_name(0)
	local otherFile

	-- generate other file name
	if string.match(currentFileName, "_test") then
		-- open the non test file
		otherFile = string.gsub(currentFileName, "_test", "")
	else
		-- open the test file
		otherFile = string.gsub(currentFileName, ".go", "_test.go")
	end

	-- open file if it exists
	local f = io.open(otherFile, "r")
	if f ~= nil then
		io.close(f)
		vim.cmd("e " .. otherFile)
	else
		print("Other file doesn't exist")
	end
end
-- vim.keymap.set("n", "<leader>tt", ":lua SwapImplTest()<CR>", {remap = false})
-- vim.keymap.set("n", "<leader>ap", ":ALEPopulateQuickfix<CR>", {remap = false})
-- vim.keymap.set("n", "<leader>T", ":TestNearest<CR>", {remap = false})
vim.cmd[[
  let g:test#echo_command = 1
]]

vim.keymap.set("n", "<leader>M", ":redir @a | silent map | redir END | new | put a<CR>", {remap = false})

-- vim.keymap.set("t", "<Leader>t", "<C-\\><C-n>:ToggleTerm<CR>", {remap = false})
vim.keymap.set("n", "<Leader>t", ":ToggleTerm<CR>", {remap = false})

vim.keymap.set("n", "<Leader>e", function()
	vim.diagnostic.open_float(0, { focusable = true })
end
, {remap = false})

-- vim.keymap.set('n', '[[', ':normal! [m<CR>', { remap = false})
-- vim.keymap.set('n', ']]', ':normal! ]m<CR>', { remap = false})

-- [v]ariable [v]???
-- 下段にインサート
vim.keymap.set('n', '<leader>vv', function()
  local word = vim.fn.expand('<cword>')
  local escaped = word:gsub("%$", "\\$")

  local lines = {
    'echo "\\n-----------' .. escaped .. ' >>>-----------\\n";',
    'echo var_dump(' .. word .. ');',
    'echo "\\n-----------' .. escaped .. ' <<<-----------\\n";',
  }

  local result = table.concat(lines, '\n')

  -- クリップボードにコピー
  vim.fn.setreg('+', result)

  -- 下の行に挿入
  local row = vim.fn.line('.')
  vim.fn.append(row, lines)

  print('Inserted and copied debug print for variable: ' .. word)
end, { noremap = true, silent = true })

-- [v]ariable [d]ump
-- クリップボードにコピーするだけ
vim.keymap.set('n', '<leader>vd', function()
  local word = vim.fn.expand('<cword>')
  local escaped = word:gsub("%$", "\\$")  -- $ を \$ に変換

  local lines = {
    'echo "\\n-----------' .. escaped .. ' >>>-----------\\n";',
    'echo var_dump(' .. word .. ');',
    'echo "\\n-----------' .. escaped .. ' <<<-----------\\n";',
  }

  local result = table.concat(lines, '\n')
  vim.fn.setreg('+', result)
  print('Copied debug print for variable: ' .. word)
end, { noremap = true, silent = true })


-- surround
vim.keymap.set('n', '<leader>k', function()
  vim.cmd("normal ysiw'")
  print('surrounded a word.')
end, { remap = false, silent = true })
