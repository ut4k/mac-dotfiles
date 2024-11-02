-- -----------------------------------------
-- aerial.nvim
-- -----------------------------------------
require('aerial').setup({
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
    "Class",
    -- "Constructor",
    -- "Enum",
    "Function",
    -- "Interface",
    -- "Module",
    "Method",
    -- "Struct",
  },
  -- float = {
  --   relative = "editor",
  --   override = function(conf)
  --     local padding = 4
  --     conf.anchor = 'NE'
  --     conf.row = padding
  --     conf.col = vim.o.columns - padding
  --     return conf
  --   end,
  -- }
	 on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle right<CR>', {buffer = bufnr})
  end
})


-- vim.keymap.set('n', '<leader>at', ':AerialToggle right<cr>', options)
-- vim.keymap.set('n', '<leader>af', ':AerialToggle float<cr>', options)
