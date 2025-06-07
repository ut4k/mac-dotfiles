-- -----------------------------------------
-- aerial.nvim
-- -----------------------------------------
require('aerial').setup({
    backends = { "lsp", "treesitter", "markdown" },
	layout = {
	  placement = "window",
    max_width = { 40, 0.2 },
    width = nil,
    min_width = 60,
	},
	float = {
    border = "rounded",
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.1 },
	},
  filter_kind = {
    "Namespace",
    "Class",
    -- "Constructor",
    -- "Enum",
    "Function",
    -- "Interface",
    -- "Module",
    "Method",
    -- "Struct",
  },
  -- Disable aerial on files with this many lines
  disable_max_lines = 100000,
  -- Disable aerial on files this size or larger (in bytes)
  disable_max_size = 20000000, -- Default 2MB
	 on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle right<CR>', {buffer = bufnr})
  end
})
