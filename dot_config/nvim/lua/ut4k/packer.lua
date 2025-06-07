-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup({function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- telescope (fuzzy finder)
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end
	}

	-- Harpoon (file switcher) from the man himself...
	use 'ThePrimeagen/harpoon'

	-- file explorer (replacement for ntrw)
	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	}

	-- status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}

	-- color scheme
	use({ 'rose-pine/neovim', as = 'rose-pine' })
	use({ 'catppuccin/nvim', as = 'catppuccin' })
	use({ 'jnurmine/Zenburn', as = 'zenburn' })
	use({ 'morhetz/gruvbox', as = 'gruvbox' })
	use({ 'whatyouhide/vim-gotham', as = 'gotham' })

	-- git tools
	-- use 'airblade/vim-gitgutter' -- buggy, with temp folder write errors and stuff
	use('mhinz/vim-signify', {run = ':SignifyEnableAll'})

	-- format of code and syntax
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

	-- emmet
	use('mattn/emmet-vim')

	-- comment
	use('terrortylor/nvim-comment')

	-- marks view in gutter
	-- use('chentoast/marks.nvim')
	use('kshenoy/vim-signature')

	-- vim surround, can't live without it!
	use('tpope/vim-surround')

	-- slp support : lsp-zero
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
				'williamboman/mason.nvim',
				run =  ':MasonUpdate'
			},
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion

			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'hrsh7th/cmp-cmdline'},
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required

			{'hrsh7th/vim-vsnip'},
			{'hrsh7th/vim-vsnip-integ'},
			{'hrsh7th/cmp-vsnip'}, -- Vsnip
		}
	}

	-- smarty support
	use "blueyed/smarty.vim"
	
	-- code format
	use "junegunn/vim-easy-align"
	
	-- golang
	-- use "fatih/vim-go"
	
	-- debugger
	use "mfussenegger/nvim-dap"
	use "rcarriga/nvim-dap-ui"
	use 'theHamsta/nvim-dap-virtual-text'
	use "leoluz/nvim-dap-go"
	use "nvim-neotest/nvim-nio"

	-- workspace switching
	use {'nvim-telescope/telescope-project.nvim'}

	-- outline
	use 'stevearc/aerial.nvim'
	use 'anuvyklack/hydra.nvim' 

	-- use {
		-- 'nvim-pack/nvim-spectre',
		-- requires = { {'nvim-lua/plenary.nvim'} }
	-- }

	use "rebelot/kanagawa.nvim"
	-- use 'mfussenegger/nvim-lint'
	use 'kevinhwang91/nvim-bqf'
	use 'folke/todo-comments.nvim'
	-- use {
	-- 	'folke/noice.nvim',
	-- 	requires = {
	-- 		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	-- 		"MunifTanjim/nui.nvim",
	-- 		-- OPTIONAL:
	-- 		--   `nvim-notify` is only needed, if you want to use the notification view.
	-- 		--   If not available, we use `mini` as the fallback
	-- 		"rcarriga/nvim-notify",
	-- 	}
	-- }
	use {"akinsho/toggleterm.nvim", tag = '*'}
	-- use 'dense-analysis/ale'

	-- use 'ray-x/go.nvim'
	-- use 'ray-x/guihua.lua'

	-- use {
	-- 	"narutoxy/dim.lua",
	-- 	requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
	-- }
	-- use 'vim-test/vim-test'
	-- use 'hrsh7th/vim-eft'
	-- use 'mg979/vim-visual-multi'

	-- vim.cmd[[
	-- aug VMlens
	-- au!
	-- au User visual_multi_start lua require('vmlens').start()
	-- au User visual_multi_exit lua require('vmlens').exit()
	-- aug END
	-- ]]

	-- use 'kevinhwang91/nvim-hlslens'
	use 'haya14busa/vim-asterisk'

	-- use {
	-- 	'mrcjkb/haskell-tools.nvim',
	-- 	requires = {
	-- 		'nvim-lua/plenary.nvim',
	-- 	},
	-- 	version = '^2', -- Recommended
	-- }

	-- use 'neovimhaskell/haskell-vim'
	use "adalessa/laravel.nvim"
	use { 'mhartington/formatter.nvim' }
	use { "stevearc/conform.nvim" }
	use {
		'nmac427/guess-indent.nvim',
		config = function() require('guess-indent').setup {} end,
	}
	use { "axkirillov/telescope-changed-files" }
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
	use { 'praem90/nvim-phpcsf' }
	use 'mfussenegger/nvim-lint'
	-- use { "praem90/neotest-docker-phpunit.nvim" }
	-- use {
	-- 	"nvim-neotest/neotest",
	-- 	requires = {
	-- 		"nvim-neotest/nvim-nio",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"antoinemadec/FixCursorHold.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"olimorris/neotest-phpunit",
	-- 	}
	-- }
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})

