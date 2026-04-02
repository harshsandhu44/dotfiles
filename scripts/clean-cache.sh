#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=false
SKIP_SYSTEM=false

for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --no-system) SKIP_SYSTEM=true ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

section() { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }
ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
info()    { echo -e "  ${BLUE}·${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }

run() {
  if $DRY_RUN; then
    echo -e "  ${BLUE}(dry-run)${NC} $*"
  else
    "$@"
  fi
}

sudo_run() {
  if $DRY_RUN; then
    echo -e "  ${BLUE}(dry-run)${NC} sudo $*"
  else
    sudo "$@"
  fi
}

$DRY_RUN && echo -e "${YELLOW}Dry run mode — nothing will be deleted${NC}"

TOTAL_FREED_KB=0

dir_size_kb() {
  local path="$1"
  [[ -e "$path" ]] || { echo 0; return; }
  { du -sk "$path" 2>/dev/null || true; } | awk '{size=$1} END{print size+0}'
}

kb_to_human() {
  local kb="$1"
  if (( kb >= 1048576 )); then
    awk "BEGIN { printf \"%.1fG\", $kb / 1048576 }"
  elif (( kb >= 1024 )); then
    awk "BEGIN { printf \"%.1fM\", $kb / 1024 }"
  else
    echo "${kb}k"
  fi
}

add_freed() {
  local before="$1" after="$2"
  local freed=$(( before - after ))
  (( freed < 0 )) && freed=0
  TOTAL_FREED_KB=$(( TOTAL_FREED_KB + freed ))
}

freed_kb() {
  local before="$1" after="$2"
  local freed=$(( before - after ))
  (( freed < 0 )) && freed=0
  echo "$freed"
}

# ─── User Caches ─────────────────────────────────────────────────────────────

clean_user_caches() {
  local path="$HOME/Library/Caches"
  [[ -d "$path" ]] || { info "~/Library/Caches not found, skipping"; return; }
  local before
  before=$(dir_size_kb "$path")
  info "User caches before: $(kb_to_human "$before")"
  run rm -rf "${path:?}"/* 2>/dev/null || true
  local after
  after=$(dir_size_kb "$path")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "User caches cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_user_logs() {
  local path="$HOME/Library/Logs"
  [[ -d "$path" ]] || { info "~/Library/Logs not found, skipping"; return; }
  local before
  before=$(dir_size_kb "$path")
  info "User logs before: $(kb_to_human "$before")"
  run rm -rf "${path:?}"/* 2>/dev/null || true
  local after
  after=$(dir_size_kb "$path")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "User logs cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_xcode_derived_data() {
  local path="$HOME/Library/Developer/Xcode/DerivedData"
  [[ -d "$path" ]] || { info "Xcode DerivedData not found, skipping"; return; }
  local before
  before=$(dir_size_kb "$path")
  info "Xcode DerivedData before: $(kb_to_human "$before")"
  run rm -rf "${path:?}"/* 2>/dev/null || true
  local after
  after=$(dir_size_kb "$path")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "Xcode DerivedData cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_trash() {
  local path="$HOME/.Trash"
  [[ -d "$path" ]] || { info "Trash not found, skipping"; return; }
  local before
  before=$(dir_size_kb "$path")
  info "Trash before: $(kb_to_human "$before")"
  run rm -rf "${path:?}"/* 2>/dev/null || true
  local after
  after=$(dir_size_kb "$path")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "Trash emptied (freed ~$(kb_to_human "$freed"))"
}

# ─── Package Manager Caches ──────────────────────────────────────────────────

clean_homebrew() {
  command -v brew &>/dev/null || { info "Homebrew not installed, skipping"; return; }
  local cache_dir
  cache_dir=$(brew --cache)
  local before
  before=$(dir_size_kb "$cache_dir")
  info "Homebrew cache before: $(kb_to_human "$before")"
  run brew cleanup --prune=all
  local after
  after=$(dir_size_kb "$cache_dir")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "Homebrew cache cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_npm() {
  command -v npm &>/dev/null || { info "npm not installed, skipping"; return; }
  local cache_dir
  cache_dir=$(npm config get cache 2>/dev/null)
  local before
  before=$(dir_size_kb "$cache_dir")
  info "npm cache before: $(kb_to_human "$before")"
  run npm cache clean --force
  local after
  after=$(dir_size_kb "$cache_dir")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "npm cache cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_yarn() {
  command -v yarn &>/dev/null || { info "Yarn not installed, skipping"; return; }
  local cache_dir
  cache_dir=$(yarn cache dir 2>/dev/null || echo "$HOME/Library/Caches/yarn")
  local before
  before=$(dir_size_kb "$cache_dir")
  info "Yarn cache before: $(kb_to_human "$before")"
  run yarn cache clean
  local after
  after=$(dir_size_kb "$cache_dir")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "Yarn cache cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_pip() {
  local pip_cmd=""
  command -v pip3 &>/dev/null && pip_cmd="pip3"
  command -v pip &>/dev/null && [[ -z "$pip_cmd" ]] && pip_cmd="pip"
  [[ -n "$pip_cmd" ]] || { info "pip not installed, skipping"; return; }
  local cache_dir
  cache_dir=$($pip_cmd cache dir 2>/dev/null || echo "")
  if [[ -z "$cache_dir" ]]; then
    info "pip cache dir not found, skipping"
    return
  fi
  local before
  before=$(dir_size_kb "$cache_dir")
  info "pip cache before: $(kb_to_human "$before")"
  run $pip_cmd cache purge
  local after
  after=$(dir_size_kb "$cache_dir")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "pip cache cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_cargo() {
  command -v cargo &>/dev/null || { info "Cargo not installed, skipping"; return; }
  if command -v cargo-cache &>/dev/null; then
    local before
    before=$(dir_size_kb "$HOME/.cargo")
    info "Cargo cache before: $(kb_to_human "$before")"
    run cargo cache --autoclean
    local after
    after=$(dir_size_kb "$HOME/.cargo")
    local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
    ok "Cargo cache cleaned (freed ~$(kb_to_human "$freed"))"
  else
    warn "cargo-cache not installed; cleaning registry/cache and git/db manually"
    for subdir in "$HOME/.cargo/registry/cache" "$HOME/.cargo/git/db"; do
      [[ -d "$subdir" ]] || continue
      local before
      before=$(dir_size_kb "$subdir")
      info "$(basename "$(dirname "$subdir")")/$(basename "$subdir") before: $(kb_to_human "$before")"
      run rm -rf "${subdir:?}"/*
      local after
      after=$(dir_size_kb "$subdir")
      local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
      ok "Cleaned $subdir (freed ~$(kb_to_human "$freed"))"
    done
  fi
}

# ─── System Caches ───────────────────────────────────────────────────────────

clean_system_caches() {
  if $SKIP_SYSTEM; then
    info "Skipping system caches (--no-system)"
    return
  fi
  if ! sudo -n true 2>/dev/null; then
    warn "System cache cleaning requires sudo — run with an active sudo session or pass --no-system"
    return
  fi
  local path="/Library/Caches"
  local before
  before=$(dir_size_kb "$path")
  info "System caches before: $(kb_to_human "$before")"
  sudo_run rm -rf "${path:?}"/* 2>/dev/null || true
  local after
  after=$(dir_size_kb "$path")
  local freed; freed=$(freed_kb "$before" "$after"); add_freed "$before" "$after"
  ok "System caches cleaned (freed ~$(kb_to_human "$freed"))"
}

clean_system_logs() {
  if $SKIP_SYSTEM; then return; fi
  if ! sudo -n true 2>/dev/null; then return; fi
  local count=0
  for logfile in /var/log/*.log; do
    [[ -f "$logfile" ]] || continue
    sudo_run rm -f "$logfile"
    count=$(( count + 1 ))
  done
  ok "Removed $count system log files from /var/log"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  section "User Caches"
  clean_user_caches
  clean_user_logs
  clean_xcode_derived_data
  clean_trash

  section "Package Manager Caches"
  clean_homebrew
  clean_npm
  clean_yarn
  clean_pip
  clean_cargo

  if ! $SKIP_SYSTEM; then
    section "System Caches"
    clean_system_caches
    clean_system_logs
  fi

  section "Summary"
  echo -e "  ${GREEN}Total freed (estimated): $(kb_to_human "$TOTAL_FREED_KB")${NC}"
  if $DRY_RUN; then echo -e "  ${YELLOW}No files were actually deleted (dry-run mode)${NC}"; fi
}

main
