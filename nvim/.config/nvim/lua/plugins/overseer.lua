return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerRunCmd",
      "OverseerToggle",
      "OverseerOpen",
      "OverseerQuickAction",
    },
    opts = {
      task_list = {
        direction = "right",
        min_width = 40,
        max_width = { 60, 0.4 },
        default_detail = 1,
      },
      templates = { "builtin" },
    },
  },
}
