-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

local telescope = require("telescope.builtin")

local function code_action_only(kind)
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { kind },
      diagnostics = {},
    },
  })
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

-- Telescope
map("n", "<leader>sf", telescope.find_files, { desc = "Find Files" })
map("n", "<leader>sF", function()
  telescope.find_files({ hidden = true })
end, { desc = "Find All Files (hidden)" })
map("n", "<leader>sg", telescope.live_grep, { desc = "Live Grep" })
map("n", "<leader>sw", telescope.grep_string, { desc = "Grep Word Under Cursor" })
map("n", "<leader>s/", function()
  telescope.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "Live Grep in Open Files" })
map("n", "<leader>?", telescope.oldfiles, { desc = "Find Recently Opened Files" })
map("n", "<leader>s.", telescope.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
map("n", "<leader>sb", telescope.buffers, { desc = "Search Buffers" })
map("n", "<leader>sm", telescope.marks, { desc = "Search Marks" })
map("n", "<leader>sh", telescope.help_tags, { desc = "Search Help" })
map("n", "<leader>sd", telescope.diagnostics, { desc = "Search Diagnostics" })
map("n", "<leader>sr", telescope.resume, { desc = "Search Resume" })
map("n", "<leader>sds", function()
  telescope.lsp_document_symbols({
    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Property" },
  })
end, { desc = "Search LSP Document Symbols" })

-- Git (Telescope)
map("n", "<leader>gf", telescope.git_files, { desc = "Search Git Files" })
map("n", "<leader>gc", telescope.git_commits, { desc = "Search Git Commits" })
map("n", "<leader>gcf", telescope.git_bcommits, { desc = "Search Git Commits for Current File" })
map("n", "<leader>gl", function()
  require("snacks").lazygit.log_file()
end, { desc = "Git Log (open)" })
map("n", "<leader>gL", function()
  require("snacks").lazygit.log()
end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", telescope.git_branches, { desc = "Search Git Branches" })
map("n", "<leader>gs", telescope.git_status, { desc = "Search Git Status (diff view)" })

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
