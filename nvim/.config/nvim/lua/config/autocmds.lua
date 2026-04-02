-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local save_pipeline = vim.api.nvim_create_augroup("user_save_pipeline", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = save_pipeline,
  callback = function(event)
    local file = event.match
    if file == "" then
      return
    end
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = save_pipeline,
  callback = function(event)
    if vim.bo[event.buf].binary then
      return
    end
    if vim.tbl_contains({ "markdown", "gitcommit" }, vim.bo[event.buf].filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = save_pipeline,
  callback = function()
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({ lsp_fallback = true })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = save_pipeline,
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then
      lint.try_lint()
    end
  end,
})
