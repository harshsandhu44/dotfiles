return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false,
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = false,
          git_status_open = true,
          diagnostics_open = true,
          layout = {
            layout = {
              width = 45,
            },
          },
        },
        files = {
          hidden = false,
        },
      },
      icons = {
        files = {
          enabled = true,
          dir = "󰉋 ",
          dir_open = "󰝰 ",
          file = "󰈔 ",
        },
        tree = {
          -- vertical = "│ ",
          -- middle = "├╴",
          -- last = "└╴",
          vertical = "  ",
          middle = " ",
          last = "- ",
        },
        git = {
          enabled = true,
          staged = "●",
          added = "",
          deleted = "",
          ignored = "◌",
          modified = "○",
          renamed = "󰁕",
          unmerged = "",
          untracked = "",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = "󰌶 ",
          Info = " ",
        },
        ui = {
          live = "󰐰 ",
          hidden = "h",
          ignored = "i",
          follow = "f",
          selected = "● ",
          unselected = "○ ",
        },
      },
    },
  },
  keys = {
    {
      "<leader>gg",
      function()
        require("snacks").lazygit.open()
      end,
      desc = "Open lazygit",
    },
    {
      "<leader>gi",
      function()
        require("snacks").picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        require("snacks").picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        require("snacks").picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        require("snacks").picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
  },
}
