local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

-- Configure LSP
local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
-- local util = require('lspconfig').util

-- LUA
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
-- lspconfig.lua_ls.setup({
-- 			cmd = {"C:\\Users\\kimura.AZET\\AppData\\Local\\nvim-prime-data\\mason\\packages\\lua-language-server\\bin\\lua-language-server.exe"},
-- })

lspconfig.hls.setup(lsp)

-- srn go settings
lspconfig.gopls.setup({
	cmd_env = { GOFLAGS = "-tags=test_fixture,test_login" },
})
-- golangcilsp (lint)
-- if not configs.golangcilsp then
--  	configs.golangcilsp = {
-- 		default_config = {
-- 			-- cmd = {'golangci-lint-langserver'},
-- 			cmd = {'C:\\Users\\kimura.AZET\\go\\bin\\golangci-lint-langserver.exe'},
-- 			root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
-- 			init_options = {
-- 					command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" };
-- 			}
-- 		};
-- 	}
-- end
-- lspconfig.golangci_lint_ls.setup {
-- 	filetypes = {'go','gomod'}
-- }

-- Configure PHP WP LSP
--
--require 'lspconfig'.intelephense.setup {
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
--
lspconfig.intelephense.setup({
	-- root_dir = util.root_pattern(".git", "index.php"),
	root_dir = require("lspconfig").util.root_pattern(".git", ".svn", "package.json"),
	single_file_support = true,
	settings = {
		intelephense = {
      environment = {
        includePaths = {
					'./vendor',
					'./../vendor',
					'./../../vendor',
					'./../../../vendor',
				},
        excludePaths = { },
      },
			format = {
				enable = true,
				-- enable = false,
			},
			capabilities = capabilities,
			stubs = {
				"bcmath",
				"bz2",
				"Core",
				"curl",
				"date",
				"dom",
				"fileinfo",
				"filter",
				"gd",
				"gettext",
				"hash",
				"iconv",
				"imap",
				"intl",
				"json",
				"libxml",
				"mbstring",
				"mcrypt",
				"mysql",
				"mysqli",
				"password",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_mysql",
				"Phar",
				"readline",
				"regex",
				"session",
				"SimpleXML",
				"sockets",
				"sodium",
				"standard",
				"superglobals",
				"tokenizer",
				"xml",
				"xdebug",
				"xmlreader",
				"xmlwriter",
				"yaml",
				"zip",
				"zlib",
				"wordpress",
				"wordpress-stubs",
				"woocommerce-stubs",
				"acf-pro-stubs",
				"wordpress-globals",
				"wp-cli-stubs",
				"genesis-stubs",
				"polylang-stubs",
			},
		},
	},
})

-- add html support
lspconfig.html.setup(lsp)
-- add css support (removed, causes errors, until I can fix it)
-- lspconfig.css.setup(lsp)
lsp.setup()

-- completion
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	mapping = {
		["<Tab>"] = cmp_action.tab_complete(),
		["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	experimental = {
		ghost_text = true, -- this feature conflict with copilot.vim's preview.
	},
})
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
-- 	focusable = false,
-- 	border = "single",
-- })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- 新しいハンドラのスタイルで hover の表示をカスタム
    client.handlers["textDocument/hover"] = function(err, result, ctx, config)
      config = config or {}
      config.border = "single"
      config.focusable = false
      vim.lsp.handlers.hover(err, result, ctx, config)
    end
  end,
})


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = " ",
		spacing = 2,
	},
	signs = true,
	underline = true,
  focusable = false,
	--   virtual_text = false,
	-- float = {boder = "single" },
})

-- Sign configuration
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignInfo" })

-- 保存時自動フォーマット
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = { "*.php" },
-- 	callback = function()
-- 		vim.lsp.buf.format({ formatting_options = { tabSize = 2, insertSpaces = true } })
-- 	end,
-- })

-- <Leader>e を押すと別のフローティングウィンドウでdiagnosticが表示される設定
vim.keymap.set("n", "<Leader>dg", function()
	local diagnostics = vim.diagnostic.get(0)

	-- フローティングウィンドウを開く
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufnr, true, {
		relative = "cursor",
		width = 100,
		height = #diagnostics + 2,
		row = 1,
		col = 1,
		focusable = true,
		style = "minimal",
		border = "double",
	})

	local lines = {}
	for _, diagnostic in ipairs(diagnostics) do
		local line_str = string.format("%s", diagnostic.message or "")
		line_str = line_str:gsub("\n", "\\n")
		table.insert(lines, line_str)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end, { silent = true, noremap = true })

-- tsserverを無効にしてangularlsを優先
-- lspconfig.tsserver.setup({
--   root_dir = lspconfig.util.root_pattern('webpack.mix.js', '.git'),
--   on_attach = function(client, bufnr)
--     -- Angularプロジェクトの場合はtsserverを停止してangularlsを使う
--     local has_angularls = lspconfig.util.root_pattern('webpack.mix.js')(client.workspace_folders[1].name)
--     print("has angl: " .. has_angularls) -- ルートディレクトリを確認
--     if has_angularls then
--       client.stop()
--     end
--   end
-- })

-- AngularJSファイルに対してangularlsをアタッチ
lspconfig.angularls.setup({
  root_dir = lspconfig.util.root_pattern('webpack.mix.js', '.git'),
  filetypes = { "typescript", "html", "javascript" }, -- ファイルタイプの明示
  on_attach = function(client, bufnr)
    -- カスタマイズ可能
  end
})

vim.keymap.set({'n', 'x'}, '<leader>y', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
