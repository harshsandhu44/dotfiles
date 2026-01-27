return {
  -- Disable animation for mini.indentscope
  {
    "nvim-mini/mini.indentscope",
    opts = {
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },

  -- Change notification style to static (no animation)
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "static",
    },
  },

  -- Disable animation in mini.animate
  {
    "nvim-mini/mini.animate",
    enabled = false,
  },
}
