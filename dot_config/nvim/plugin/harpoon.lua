require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 1,
    },
    global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,
        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = false,
    },
})

-- add mark/file to harpoon
vim.keymap.set("n", "<leader>ha", function()
	require("harpoon.mark").add_file()
	print("Mark added.")
end, {remap=false})

-- show the harpoon list
vim.keymap.set("n", "<leader>hh", function()
	require("harpoon.ui").toggle_quick_menu()
end, {remap=false})

