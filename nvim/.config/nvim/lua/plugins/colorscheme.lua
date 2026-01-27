return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night", -- 'night' is the darkest variant
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        colors.bg = "#18181b" -- nearly black background
        colors.bg_dark = "#18181b"
        colors.bg_float = "#18181b"
        colors.bg_sidebar = "#18181b"
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
