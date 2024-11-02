-- ref: https://github.com/potamides/dotfiles/blob/master/.config/nvim/init.lua

vim.opt.updatetime = 500
-- display
vim.opt.showmode = false
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.wildmode = "full"
vim.opt.wildmenu = true
vim.opt.scrolloff = 5
vim.opt.termguicolors = true
vim.wo.wrap = false

vim.opt.ambiwidth="single"

-- tabs are two spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- search related
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.magic = false
-- 周回する
vim.opt.wrapscan = true

-- set list chars for horizontal scrolling
-- vim.opt.listchars:append{tab = "» ", precedes = "<", extends = ">"}
vim.cmd[[
 set listchars=tab:»\ ,space:·,trail:·,nbsp:␣,eol:↲,extends:»,precedes:«
]]
vim.opt.list = true

-- show line numbers and highlight cursor line number
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- mouse and clipboard integration
-- vim.opt.clipboard = "unnamedplus"
-- vim.opt.clipboard = "unnamed"
-- vim.opt.clipboard = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- set an alternative layout that can be switched to in insert mode with CTRL-^
-- vim.opt.keymap = "kana" -- not using that until I know what id does...
vim.opt.iminsert = 0

vim.opt.title = true
-- vim.opt.titlestring=vim.fn.expand("%:p:h")
vim.opt.titlestring=vim.fn.getcwd()

-- vim.cmd("GuiRenderLigatures 0")

vim.opt.foldenable = false
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = '{{{,}}}'

-- vim.opt.nofixeol = true
vim.cmd("set nofixeol")
