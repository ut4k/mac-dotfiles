
-- trying to reset IME to romaji when we leave insertMode
-- spoiler alert: not working...
AugroupIME = vim.api.nvim_create_augroup("IMEreset", {clear = true})
vim.api.nvim_create_autocmd("InsertLeave", {
	command = "set iminsert=0",
	group = AugroupIME,
})

-- auto open location list after a :vim or :grep command
vim.api.nvim_exec([[
	augroup autolocationlist
		autocmd!
		autocmd QuickFixCmdPost [^l]* cwindow | redraw
	augroup END
]], false)


-- auto reload files when changed on disk
vim.api.nvim_exec([[
	set autoread
	augroup autoreload
		autocmd!
		autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
	augroup END
]], false)

-- auto format go files when saving
vim.api.nvim_exec([[
	augroup autogofmt
		autocmd!
		autocmd BufWritePost *.go silent! !go fmt %
	augroup END
]], false)

-- function jump for go using Aerial
vim.api.nvim_exec([=[
augroup gojumpremap
  autocmd!
  autocmd Filetype go nnoremap [[ :AerialPrev<CR>
  autocmd Filetype go nnoremap ]] :AerialNext<CR>
augroup END
]=], false)

-- カレントフォルダをタイトルバーに表示
-- vim.api.nvim_exec([[
-- augroup dirchange
--    autocmd!
--    autocmd BufEnter * let &titlestring=v:event['cwd']
-- augroup END
-- ]], false)

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*" },
	callback = function()
		vim.opt.titlestring = "📁 " .. vim.fn.getcwd() .. " ⟩ 📄 " .. vim.fn.expand("%:~:.")
	end,
	group = vim.api.nvim_create_augroup('autotitle', {}),
})

vim.api.nvim_exec([[
	autocmd FileType php set commentstring=//\ %s
]], false)

vim.api.nvim_create_autocmd(
    "CursorHold",
    {
        pattern = {"*"},
        callback = vim.lsp.buf.hover
    }
)

-- local TIMEOUT = 3000
-- local timer = vim.loop.new_timer()
-- vim.on_key(function()
--   timer:start(TIMEOUT, 0, function()
--     vim.lsp.buf.hover()
--   end)
-- end)

vim.cmd[[
function DisableSyntaxTreesitter()
    if exists(':TSBufDisable')
        exec 'TSBufDisable autotag'
        exec 'TSBufDisable highlight'
        exec 'TSBufDisable incremental_selection'
        exec 'TSBufDisable indent'
        exec 'TSBufDisable playground'
        exec 'TSBufDisable query_linter'
        exec 'TSBufDisable rainbow'
        exec 'TSBufDisable refactor.highlight_definitions'
        exec 'TSBufDisable refactor.navigation'
        exec 'TSBufDisable refactor.smart_rename'
        exec 'TSBufDisable refactor.highlight_current_scope'
        exec 'TSBufDisable textobjects.swap'
        " exec 'TSBufDisable textobjects.move'
        exec 'TSBufDisable textobjects.lsp_interop'
        exec 'TSBufDisable textobjects.select'
    endif

    set foldmethod=manual
endfunction

augroup BigFileDisable
    autocmd!
    autocmd BufReadPre,FileReadPre * if getfsize(expand("%")) > 512 * 1024 | exec DisableSyntaxTreesitter() | endif
augroup END
]]
