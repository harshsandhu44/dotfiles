return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  keys = function()
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end
      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({ results = file_paths }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    local keys = {
      {
        "<leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          toggle_telescope(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
