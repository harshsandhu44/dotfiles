return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
  },
  opts = function()
    return {
      adapters = {
        require("neotest-jest")({
          jestCommand = function()
            local pm = nil
            local cwd = vim.uv.cwd() or vim.fn.getcwd()
            if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
              pm = "pnpm"
            elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
              pm = "yarn"
            elseif vim.fn.filereadable(cwd .. "/package.json") == 1 then
              pm = "npm"
            end
            if pm then
              return pm .. " test --"
            end
            return "jest"
          end,
        }),
        require("neotest-rust"),
      },
    }
  end,
  keys = {
    { "<leader>tn", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test Output" },
    { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop Test" },
  },
}
