require("toggleterm").setup({
  open_mapping = [[<c-\>]], -- Ctrl+\ でターミナルを開閉
  direction = 'float'
})

-- ターミナルをトグルする関数
-- function RunNearestTestInTerm(direction_)
--   local cmd = "~/scripts/run_phpunit_docker_knowbe_api.sh --filter=" .. "'" .. SymbolNameToReg() .. "'"
--   local Terminal = require("toggleterm.terminal").Terminal
--   local phpunit_test = Terminal:new({
--     direction = direction_,
--     persist_mode = true,
--     close_on_exit = false,
--     hidden = true,
--   })
--   phpunit_test:open()
--   phpunit_test:send(cmd, false)
-- end

function RunNearestTestInTerm(direction_)
  local test_file = vim.fn.expand("%:.")
  local filter = SymbolNameToReg()
  local cmd = "~/scripts/run_phpunit_docker_knowbe_api.sh " .. test_file .. " --filter='" .. filter .. "'"
  local Terminal = require("toggleterm.terminal").Terminal
  local phpunit_test = Terminal:new({
    direction = direction_,
    persist_mode = true,
    close_on_exit = false,
    hidden = true,
  })
  phpunit_test:open()
  phpunit_test:send(cmd, false)
end

function RunTestFileInTerm(direction_)
  local cmd = "~/scripts/run_phpunit_docker_knowbe_api.sh " .. vim.fn.expand("%:.")
  local Terminal = require("toggleterm.terminal").Terminal
  local phpunit_test = Terminal:new({
    direction = direction_,
    persist_mode = true,
    close_on_exit = false,
    hidden = true,
  })
  phpunit_test:open()
  phpunit_test:send(cmd, false)
end

-- [r]un [t]est
vim.api.nvim_set_keymap("n", "<leader>rt", "<cmd>lua RunNearestTestInTerm('float')<CR>", { noremap = true, silent = true })
-- [r]un e[x]act file
vim.api.nvim_set_keymap("n", "<leader>rx", "<cmd>lua RunTestFileInTerm('float')<CR>", { noremap = true, silent = true })

-- --------------------
