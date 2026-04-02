# Workflow Quick Reference

## Session Management

- `muxx` — launch fzf session picker from shell
- `<prefix> O` — open session picker from inside tmux
- `<prefix> P` — jump to last session
- `Ctrl+d` (in picker) — kill selected session

## Tmux

Prefix: `Ctrl+Space`

| Key                | Action                              |
| ------------------ | ----------------------------------- |
| `<prefix> \|`      | Split pane horizontally             |
| `<prefix> -`       | Split pane vertically               |
| `Ctrl+h/j/k/l`     | Navigate panes (seamless with nvim) |
| `<prefix> H/J/K/L` | Resize pane                         |
| `<prefix> c`       | New window (current path)           |
| `<prefix> \`       | Last window                         |
| `<prefix> R`       | Rename session                      |
| `<prefix> r`       | Reload tmux config                  |
| `v` (copy mode)    | Begin selection                     |
| `y` (copy mode)    | Copy to clipboard                   |
| `<prefix> p`       | Paste from clipboard                |

## Neovim

Leader: `Space`

**Files & Search**

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>sf` | Find git files         |
| `<leader>sF` | Find all files         |
| `<leader>sg` | Live grep              |
| `<leader>sw` | Grep word under cursor |

**Code**

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>ca` | Code action            |
| `<leader>cr` | Rename symbol          |
| `<leader>cf` | Format                 |
| `<leader>co` | Organize imports       |
| `K`          | Hover docs             |
| `gd`         | Go to definition       |
| `gr`         | References             |
| `]d` / `[d`  | Next / prev diagnostic |

**Git**

| Key           | Action       |
| ------------- | ------------ |
| `<leader>gg`  | LazyGit      |
| `<leader>ghs` | Stage hunk   |
| `<leader>ghu` | Unstage hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line   |

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

| Command   | Action                        |
| --------- | ----------------------------- |
| `z <dir>` | Smart directory jump (zoxide) |
| `vim`     | Opens nvim                    |
| `pls`     | sudo                          |
| `x`       | clear                         |

## Projects (sesh sessions)

| Session    | Path          |
| ---------- | ------------- |
| `dotfiles` | `~/Dotfiles/` |
