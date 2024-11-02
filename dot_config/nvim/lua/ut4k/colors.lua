
function RemoveCommentItalics()
	local comment = vim.api.nvim_get_hl(0, {name="Comment"})
	local newComment = {fg=comment['fg']}
	vim.api.nvim_set_hl(0, "Comment", newComment)
end


function CustomHl()
		vim.api.nvim_set_hl(0, "cedTODO", {bg="#990000", fg="#ffffff"})
		vim.cmd[[syntax match cedTODO / TODO/]]
		-- for some reason, TODO is not working...

		vim.api.nvim_set_hl(0, "cedDBG", {bg="#999900", fg="#ffffff"})
		vim.cmd[[syntax match cedDBG / DBG/]]
		-- maybe only the last one is working...

		vim.api.nvim_set_hl(0, "cedWIP", {bg="#009900", fg="#000000"})
		vim.cmd[[syntax match cedWIP / WIP/]]

		-- statusline
		vim.api.nvim_set_hl(0, 'StatusLineNonText', {
			fg = vim.api.nvim_get_hl_by_name('NonText', true).foreground,
			bg = vim.api.nvim_get_hl_by_name('StatusLine', true).background,
		})
end


AugroupCHL = vim.api.nvim_create_augroup("CustomHL", {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- clears italics in comments
		RemoveCommentItalics()
		-- apply my "tags" syntax highlight
		CustomHl()
	end,
	group = AugroupCHL,
})


-- @param string colorscheme name
-- @param string variant `light` or `dark`
local function ColorMyPencils(color, variant)
	-- defaults
	color = color or "rose-pine"
	variant = variant or "dark"
	-- vim setup
	vim.opt.termguicolors = true
	vim.opt.background = variant
	vim.cmd.colorscheme(color)
end

-- Dark color scheme
function ColorMyPencilsDark(color)
	color = color or "rose-pine"
	ColorMyPencils(color, "dark")

	-- custom hl for indent and space markers
	if(color=="zenburn") then
		vim.api.nvim_set_hl(0, "NonText", {fg="#656565"})
	elseif(color=="gruvbox") then
		vim.api.nvim_set_hl(0, "NonText", {fg="#4e4e4e"})
	else
		vim.api.nvim_set_hl(0, "NonText", {fg="#332f4a"})
	end
end

-- Light version
function ColorMyPencilsLight(color)
	color = color or "catppuccin"
	ColorMyPencils(color, "light")
	-- custom hl for indent and space markers
	vim.api.nvim_set_hl(0, "NonText", {fg="#e6e0da"})
end

