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
    -- use telescope to find all hidden and gitignored files, but ignore node_modules and dist folders
    telescope.find_files({
      hidden = true,
      no_ignore = true,
      find_command = { "rg", "--files", "--hidden", "--glob", "!node_modules/**", "--glob", "!dist/**" },
    })
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
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Disable arrow keys
map({ "n", "v" }, "<Left>", "<cmd>echo 'use h to move, noob!!'<CR>", { desc = "Disable Left Arrow" })
map({ "n", "v" }, "<Right>", "<cmd>echo 'use l to move, noob!!'<CR>", { desc = "Disable Right Arrow" })
map({ "n", "v" }, "<Up>", "<cmd>echo 'use k to move, noob!!'<CR>", { desc = "Disable Up Arrow" })
map({ "n", "v" }, "<Down>", "<cmd>echo 'use j to move, noob!!'<CR>", { desc = "Disable Down Arrow" })

-- Find by intent
map("n", "<leader>sf", find_git_files, { desc = "Find Git Files" })
map("n", "<leader>sF", find_all_files, { desc = "Find All Files" })
map("n", "<leader>sg", live_grep, { desc = "Live Grep" })
map("n", "<leader>sw", grep_word, { desc = "Grep Word Under Cursor" })
map("n", "<leader>s/", function()
  telescope.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })
map("n", "<leader>?", telescope.oldfiles, { desc = "[?] Find recently opened files" })
map("n", "<leader>sb", telescope.buffers, { desc = "[S]earch existing [B]uffers" })
map("n", "<leader>sm", telescope.marks, { desc = "[S]earch [M]arks" })
map("n", "<leader>gf", telescope.git_files, { desc = "Search [G]it [F]iles" })
map("n", "<leader>gc", telescope.git_commits, { desc = "Search [G]it [C]ommits" })
map("n", "<leader>gcf", telescope.git_bcommits, { desc = "Search [G]it [C]ommits for current [F]ile" })
map("n", "<leader>gb", telescope.git_branches, { desc = "Search [G]it [B]ranches" })
map("n", "<leader>gs", telescope.git_status, { desc = "Search [G]it [S]tatus (diff view)" })
map("n", "<leader>sf", telescope.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>sh", telescope.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sw", telescope.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", telescope.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", telescope.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", telescope.resume, { desc = "[S]earch [R]resume" })
map("n", "<leader>s.", telescope.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader>sds", function()
  telescope.lsp_document_symbols({
    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Property" },
  })
end, { desc = "[S]each LSP document [S]ymbols" })

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

-- Paste without overwriting the default register
map("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

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
