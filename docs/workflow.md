# Workflow Quick Reference

## Session Management

- `muxx` — launch fzf session picker from shell
- `<prefix> O` — open session picker from inside tmux
- `<prefix> P` — jump to last session
- `Ctrl+d` (in picker) — kill selected session

Sessions are auto-saved and restored via tmux-resurrect + tmux-continuum.

## Tmux

Prefix: `Ctrl+Space`

| Key                | Action                              |
| ------------------ | ----------------------------------- |
| `<prefix> \|`      | Split pane horizontally             |
| `<prefix> -`       | Split pane vertically               |
| `Ctrl+h/j/k/l`     | Navigate panes (seamless with nvim) |
| `Ctrl+\`           | Last window (seamless with nvim)    |
| `<prefix> H/J/K/L` | Resize pane                         |
| `<prefix> c`       | New window (current path)           |
| `<prefix> \`       | Last window                         |
| `<prefix> R`       | Rename session                      |
| `<prefix> r`       | Reload tmux config                  |
| `v` (copy mode)    | Begin selection                     |
| `C-v` (copy mode)  | Rectangle selection toggle          |
| `y` (copy mode)    | Copy to clipboard                   |
| `<prefix> p`       | Paste from clipboard                |

## Neovim

Leader: `Space`

**Insert Mode**

| Key  | Action              |
| ---- | ------------------- |
| `jk` | Escape insert mode  |

**Files & Search**

| Key           | Action                        |
| ------------- | ----------------------------- |
| `<leader>sf`  | Find files                    |
| `<leader>sF`  | Find all files (hidden)       |
| `<leader>gf`  | Find git files                |
| `<leader>sg`  | Live grep                     |
| `<leader>sw`  | Grep word under cursor        |
| `<leader>s/`  | Live grep in open files       |
| `<leader>s.`  | Recent files                  |
| `<leader>sb`  | Search buffers                |
| `<leader>sm`  | Search marks                  |
| `<leader>sh`  | Search help tags              |
| `<leader>sd`  | Search diagnostics            |
| `<leader>sr`  | Resume last search            |
| `<leader>sds` | Search LSP document symbols   |

**Code**

| Key           | Action                        |
| ------------- | ----------------------------- |
| `<leader>ca`  | Code action                   |
| `<leader>cr`  | Rename symbol                 |
| `<leader>cf`  | Format                        |
| `<leader>co`  | Organize imports              |
| `<leader>cF`  | Fix all                       |
| `<leader>cE`  | ESLint fix all                |
| `K`           | Hover docs                    |
| `gd`          | Go to definition              |
| `gD`          | Go to declaration             |
| `gr`          | References                    |
| `gi`          | Go to implementation          |
| `]d` / `[d`   | Next / prev diagnostic        |
| `<leader>xw`  | Workspace diagnostics (Trouble) |
| `<leader>xb`  | Buffer diagnostics (Trouble)  |

**Git**

| Key            | Action                             |
| -------------- | ---------------------------------- |
| `<leader>gg`   | LazyGit                            |
| `<leader>gc`   | Search git commits                 |
| `<leader>gcf`  | Search git commits (current file)  |
| `<leader>gb`   | Search git branches                |
| `<leader>gs`   | Git status (diff view)             |
| `<leader>gl`   | Git log (current file)             |
| `<leader>gL`   | Git log (cwd)                      |
| `<leader>ghs`  | Stage hunk                         |
| `<leader>ghu`  | Unstage hunk                       |
| `<leader>ghp`  | Preview hunk                       |
| `<leader>ghb`  | Blame line                         |

**Tasks & Tests**

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>tt` | Run tests           |
| `<leader>tb` | Build               |
| `<leader>tl` | Lint                |
| `<leader>tT` | Typecheck           |
| `<leader>tn` | Run nearest test    |
| `<leader>tf` | Run file tests      |
| `<leader>ts` | Test summary        |
| `<leader>or` | Run task (overseer) |
| `<leader>ot` | Task list           |

## Shell

| Command       | Action                                        |
| ------------- | --------------------------------------------- |
| `z <dir>`     | Smart directory jump (zoxide)                 |
| `zi`          | Interactive directory picker (zoxide + fzf)   |
| `vim`         | Opens nvim                                    |
| `pls`         | sudo                                          |
| `x`           | clear                                         |
| `cc`          | claude                                        |
| `ccr`         | claude --resume                               |
| `ccp <prompt>`| claude --print (non-interactive)              |
