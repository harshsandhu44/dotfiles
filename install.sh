#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

section() { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }
ok() { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${BLUE}·${NC} $1"; }
would() { echo -e "  ${YELLOW}~${NC} would install: $1"; }

run() {
  if $DRY_RUN; then
    echo -e "  ${BLUE}(dry-run)${NC} $*"
  else
    "$@"
  fi
}

$DRY_RUN && echo -e "${YELLOW}Dry run mode — nothing will be installed${NC}"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── 1. Homebrew ─────────────────────────────────────────────────────────────
section "Homebrew"
if ! command -v brew &>/dev/null; then
  would "Homebrew"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  ok "Homebrew already installed"
fi

# ─── 2. Brew packages ────────────────────────────────────────────────────────
section "Homebrew packages"
BREW_PACKAGES=(
  awscli
  bash
  bash-completion
  fd
  fontforge
  fzf
  gh
  lazygit
  neovim
  nvm
  btop
  ripgrep
  stow
  tmux
  tree-sitter
  zoxide
)

for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list --formula "$pkg" &>/dev/null; then
    ok "$pkg"
  else
    would "$pkg"
    run brew install "$pkg"
  fi
done

# ─── 3. Brew casks ───────────────────────────────────────────────────────────
section "Homebrew casks"
BREW_CASKS=(alacritty)

for cask in "${BREW_CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask"
  else
    would "$cask"
    run brew install --cask "$cask"
  fi
done

# ─── 4. Oh My Zsh ────────────────────────────────────────────────────────────
section "Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  ok "Already installed"
else
  would "Oh My Zsh"
  run env RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ─── 5. NVM + Node.js ────────────────────────────────────────────────────────
section "NVM + Node.js"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  would "NVM"
  run curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! nvm ls --no-colors 2>/dev/null | grep -q "lts/\|v[0-9]"; then
  would "Node.js LTS"
  if ! $DRY_RUN; then
    nvm install --lts
    nvm alias default lts/*
  fi
else
  ok "Node.js $(node --version 2>/dev/null || echo 'installed')"
fi

# ─── 6. Global npm packages ──────────────────────────────────────────────────
section "Global npm packages"
NPM_PACKAGES=(
  aws-cdk
  turbo
  vercel
  neovim
)

for pkg in "${NPM_PACKAGES[@]}"; do
  if npm list -g --depth=0 "$pkg" &>/dev/null; then
    ok "$pkg"
  else
    would "$pkg"
    run npm install -g "$pkg"
  fi
done

# ─── 7. Rust + Cargo packages ────────────────────────────────────────────────
section "Rust"
if ! command -v rustup &>/dev/null; then
  would "Rust (rustup)"
  run curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
source "$HOME/.cargo/env" 2>/dev/null || true

section "Cargo packages"
CARGO_PACKAGES=(
  "muxx"
  "gitpilot"
  "cargo-dist"
  "cargo-cache"
)

for pkg in "${CARGO_PACKAGES[@]}"; do
  if cargo install --list 2>/dev/null | grep -q "^${pkg} "; then
    ok "$pkg"
  else
    would "$pkg"
    run cargo install "$pkg" || echo -e "  ${RED}✗${NC} Failed to install $pkg (skipping)"
  fi
done

# ─── 8. Bun ──────────────────────────────────────────────────────────────────
section "Bun"
if command -v bun &>/dev/null; then
  ok "Bun $(bun --version)"
else
  would "Bun"
  run curl -fsSL https://bun.sh/install | bash
fi

# ─── 9. TPM (Tmux Plugin Manager) ────────────────────────────────────────────
section "Tmux Plugin Manager"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  ok "TPM already installed"
else
  would "TPM"
  run git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# ─── 10. Stow dotfiles ────────────────────────────────────────────────────────
section "Stow dotfiles"
cd "$DOTFILES_DIR"
for pkg in alacritty nvim tmux zsh; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    if $DRY_RUN; then
      stow --simulate --restow "$pkg" 2>&1 && ok "$pkg (no conflicts)" || echo -e "  ${RED}✗${NC} $pkg would have conflicts"
    else
      info "Stowing $pkg..."
      stow --restow "$pkg" || echo -e "  ${RED}✗${NC} Stow failed for $pkg (skipping)"
      ok "$pkg"
    fi
  fi
done

echo -e "\n${GREEN}Done!${NC} Restart your shell or run: source ~/.zshrc\n"
