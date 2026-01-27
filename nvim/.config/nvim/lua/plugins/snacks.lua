return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false,
    },
    explorer = {
      -- Show hidden files by default in the explorer/sidebar
      replace_netrw = true, -- Ensure it replaces standard file browser
    },
    picker = {
      -- Configure the file picker sources to include hidden files
      hidden = true, -- This enables hidden files globally for pickers
      explorer = {
        sources = {
          hidden = true, -- Specifically for the explorer view
          ignored = true, -- Optional: Show git-ignored files too (node_modules etc)
        },
        files = {
          hidden = true, -- For <leader>ff (Find Files)
        },
      },
    },
  },
}
