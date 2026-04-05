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
      hidden = false, -- This enables hidden files globally for pickers
      explorer = {
        sources = {
          hidden = false, -- Specifically for the explorer view
          ignored = true, -- Optional: Show git-ignored files too (node_modules etc)
        },
        files = {
          hidden = false, -- For <leader>ff (Find Files)
        },
      },
    },
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Open lazygit",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
  },
}
