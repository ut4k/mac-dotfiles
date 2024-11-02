require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
    window = {
      mappings = {
        ["H"] = false,
        ["Z"] = "toggle_hidden",
      }
    }
  }
})
