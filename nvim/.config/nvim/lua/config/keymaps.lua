-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

local telescope_ok, telescope = pcall(require, "telescope.builtin")

local function find_git_files()
  if telescope_ok then
    pcall(telescope.git_files)
  else
    vim.cmd("find .")
  end
end

local function find_all_files()
  if telescope_ok then
    telescope.find_files()
  end
end

local function live_grep()
  if telescope_ok then
    telescope.live_grep()
  end
end

local function grep_word()
  if telescope_ok then
    telescope.grep_string()
  end
end

local function code_action_only(kind)
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { kind },
      diagnostics = {},
    },
  })
end

local function package_manager()
  local cwd = vim.uv.cwd() or vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  end
  if vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
    return "yarn"
  end
  if vim.fn.filereadable(cwd .. "/package.json") == 1 then
    return "npm"
  end
  return nil
end

local function project_cmd(script)
  local pm = package_manager()
  if not pm then
    vim.notify("No JS package manager lockfile found in current project", vim.log.levels.WARN)
    return
  end

  local cmd = ""
  if pm == "npm" then
    cmd = "npm run " .. script
  elseif pm == "pnpm" then
    cmd = "pnpm " .. script
  else
    cmd = "yarn " .. script
  end

  vim.cmd({ cmd = "OverseerRunCmd", args = { cmd } })
end

-- Diagnostics
---@diagnostic disable-next-line: deprecated
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
---@diagnostic disable-next-line: deprecated
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace Diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

-- Come out of the insert mode
map("i", "jj", "<Esc>", { desc = "Escape insert mode" })

-- Disable arrow keys
map({ "n" }, "<Left>", "<cmd>echo 'use h to move, noob!!'<CR>", { desc = "Disable Left Arrow" })
map({ "n" }, "<Right>", "<cmd>echo 'use l to move, noob!!'<CR>", { desc = "Disable Right Arrow" })
map({ "n" }, "<Up>", "<cmd>echo 'use k to move, noob!!'<CR>", { desc = "Disable Up Arrow" })
map({ "n" }, "<Down>", "<cmd>echo 'use j to move, noob!!'<CR>", { desc = "Disable Down Arrow" })

-- Find by intent
map("n", "<leader>sf", find_git_files, { desc = "Find Git Files" })
map("n", "<leader>sF", find_all_files, { desc = "Find All Files" })
map("n", "<leader>sg", live_grep, { desc = "Live Grep" })
map("n", "<leader>sw", grep_word, { desc = "Grep Word Under Cursor" })

-- Refactor
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>co", function()
  code_action_only("source.organizeImports")
end, { desc = "Organize Imports" })
map("n", "<leader>cF", function()
  code_action_only("source.fixAll")
end, { desc = "Fix All" })
map("n", "<leader>cE", function()
  code_action_only("source.fixAll.eslint")
end, { desc = "ESLint Fix All" })

-- Task runner
map("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run Task" })
map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Task List" })
map("n", "<leader>oo", "<cmd>OverseerOpen<cr>", { desc = "Open Task Output" })
map("n", "<leader>ol", "<cmd>OverseerQuickAction restart<cr>", { desc = "Rerun Last Task" })
map("n", "<leader>tt", function()
  project_cmd("test")
end, { desc = "Task: Test" })
map("n", "<leader>tl", function()
  project_cmd("lint")
end, { desc = "Task: Lint" })
map("n", "<leader>tb", function()
  project_cmd("build")
end, { desc = "Task: Build" })
map("n", "<leader>tT", function()
  project_cmd("typecheck")
end, { desc = "Task: Typecheck" })

-- LazyVim LSP defaults (set by LazyVim, no need to redefine):
-- K          - Hover docs
-- gd         - Go to definition
-- gD         - Go to declaration
-- gr         - Go to references
-- gi         - Go to implementation
-- <leader>cf - Format
-- <leader>ca - Code action

-- Gitsigns inline actions
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  once = true,
  callback = function(event)
    if event.data ~= "gitsigns.nvim" then
      return
    end
    local gs = require("gitsigns")
    map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk" })
    ---@diagnostic disable-next-line: deprecated
    map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Unstage Hunk" })
    map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame Line" })
  end,
})

-- LazyGit in Neovim
map("n", "<leader>gg", function()
  if vim.fn.exists(":LazyGit") == 2 then
    vim.cmd("LazyGit")
    return
  end

  if vim.fn.executable("lazygit") == 1 then
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.terminal then
      snacks.terminal("lazygit")
    else
      vim.cmd("terminal lazygit")
    end
    return
  end

  vim.notify("lazygit binary not found in PATH", vim.log.levels.WARN)
end, { desc = "LazyGit" })
