return {
  "akinsho/bufferline.nvim",
  -- We use opts to override the default options provided by LazyVim
  opts = function(_, opts)
    -- 1. Change the separator style
    -- Options: "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
    opts.options.separator_style = "thin"

    -- 2. Always show the bufferline (even with only 1 buffer open)
    opts.options.always_show_bufferline = false

    -- 3. Show buffer numbers (optional, good for quick jumping)
    -- Options: "none" | "ordinal" | "buffer_id" | "both"
    opts.options.numbers = "none"

    -- 4. Visual tweaks
    opts.options.show_buffer_close_icons = false -- Cleaner look
    opts.options.show_close_icon = false -- Remove the big X at the right

    -- 5. Enforce offset for your sidebar (Explorer/Snacks)
    -- Update the text to match your sidebar title
    opts.options.offsets = {
      {
        filetype = "snacks_layout_box", -- or "neo-tree" if you use that
        text = "Explorer",
        highlight = "Directory",
        text_align = "center", -- "left" | "center" | "right"
        separator = true,
      },
    }

    return opts
  end,
}
