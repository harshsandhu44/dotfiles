# dotfiles

Personal macOS development environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Directory  | Config for                              |
| ---------- | --------------------------------------- |
| `nvim/`    | Neovim (LazyVim-based)                  |
| `tmux/`    | tmux                                    |
| `zsh/`     | Zsh + Oh My Zsh                         |
| `ghostty/` | Ghostty terminal (Catppuccin themes)    |
| `alacritty/` | Alacritty terminal                    |
| `btop/`    | btop resource monitor                   |
| `yazi/`    | yazi file manager                       |
| `muxx/`    | muxx session config                     |
| `fonts/`   | Patched Google Sans Code font           |
| `scripts/` | Utility shell scripts                   |

## Install

```sh
git clone https://github.com/harshsandhu44/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script:
1. Installs Homebrew and all required packages/casks
2. Sets up Oh My Zsh, NVM + Node.js LTS, Rust, and Bun
3. Installs global npm and cargo packages (`muxx`, `gitpilot`, etc.)
4. Clones TPM (Tmux Plugin Manager)
5. Symlinks configs via `stow` for: `alacritty`, `ghostty`, `nvim`, `tmux`, `zsh`

**Dry run** (preview without installing anything):

```sh
./install.sh --dry-run
```

## Manual stow

To symlink a single config:

```sh
cd ~/dotfiles
stow nvim       # links nvim/.config/nvim → ~/.config/nvim
stow tmux       # links tmux/.tmux.conf → ~/.tmux.conf
stow zsh        # links zsh/.zshrc → ~/.zshrc
```

## Quick reference

See [`docs/workflow.md`](docs/workflow.md) for tmux keybindings, Neovim shortcuts, and shell aliases.
