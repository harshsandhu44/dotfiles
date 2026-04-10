#!/usr/bin/env bash

SCRIPT="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# Shared palette — 6 standard + 6 bright ANSI colors
PALETTE=(31 32 33 34 35 36 91 92 93 94 95 96)

# Build associative array: tag -> ANSI color code
# Tags are sorted so the mapping is stable across runs
_build_color_map() {
  local data="$1"
  declare -gA TAG_COLORS
  local idx=0
  while IFS= read -r tag; do
    [ -z "$tag" ] && continue
    TAG_COLORS["$tag"]="${PALETTE[$((idx % ${#PALETTE[@]}))]}"
    ((idx++))
  done < <(printf '%s' "$data" | jq -r '[.[].tags[]] | unique | sort | .[]')
}

case "$1" in
--list)
  muxx list --json | jq -r '
      (["31","32","33","34","35","36","91","92","93","94","95","96"]) as $p |
      ([.[].tags[]] | unique | sort | to_entries |
        map({key: .value, value: $p[.key % ($p | length)]}) |
        from_entries) as $colors |
      (map(.name | length) | max) as $max |
      sort_by(if (.tags | length) > 0 then .tags[0] else "~" end) |
      .[] |
      (.name + (" " * ($max - (.name | length) + 4))) as $padded |
      if (.tags | length) > 0
      then [.name, ($padded + "[" + (.tags | map("\u001b[" + ($colors[.] // "90") + "m" + . + "\u001b[0m") | join(", ")) + "]")]
      else [.name, $padded]
      end |
      @tsv
    '
  exit 0
  ;;

--pick-dir)
  {
    command -v fd &>/dev/null &&
      fd --type d --hidden --exclude .git --exclude node_modules . "$HOME" 2>/dev/null ||
      find "$HOME" -maxdepth 5 -type d 2>/dev/null
  } | fzf \
    --prompt '  dir: ' \
    --header 'New session — select directory' \
    --bind 'tab:up,btab:down'
  exit 0
  ;;

--new-session)
  dir="$("$SCRIPT" --pick-dir)"
  [ -n "$dir" ] && muxx connect --cwd "$dir" --no-attach
  exit 0
  ;;

--rename)
  printf "Rename '%s' to: " "$2" >/dev/tty
  read -r name </dev/tty
  [ -n "$name" ] && muxx rename "$2" "$name"
  exit 0
  ;;

--tag-edit)
  session="$2"
  data=$(muxx list --json)
  all_tags=$(printf '%s' "$data" | jq -r '[.[].tags[]] | unique | .[]')
  cur_tags=$(printf '%s' "$data" | jq -r --arg s "$session" '.[] | select(.name == $s) | .tags[]')

  _build_color_map "$data"

  # Current tags first (marked ✓ in their assigned color), then others
  lines=""
  while IFS= read -r tag; do
    [ -z "$tag" ] && continue
    c="${TAG_COLORS[$tag]:-90}"
    lines+="${tag}"$'\t'"$(printf '\033[%sm✓  %s\033[0m' "$c" "$tag")"$'\n'
  done <<<"$cur_tags"
  while IFS= read -r tag; do
    [ -z "$tag" ] && continue
    printf '%s\n' "$cur_tags" | grep -qxF "$tag" && continue
    c="${TAG_COLORS[$tag]:-90}"
    lines+="${tag}"$'\t'"$(printf '\033[%sm   %s\033[0m' "$c" "$tag")"$'\n'
  done <<<"$all_tags"

  result=$(printf '%s' "$lines" | fzf \
    --multi \
    --ansi \
    --print-query \
    --prompt '  tag: ' \
    --header "$(printf '\033[90m%s\033[0m  tab=toggle  enter=apply  type new name to create' "$session")" \
    --delimiter=$'\t' \
    --with-nth=2 \
    --nth=2 \
    --bind 'tab:toggle+up,btab:toggle+down')
  fzf_exit=$?
  [ $fzf_exit -eq 130 ] && exit 0

  query=$(printf '%s\n' "$result" | head -1)
  chosen=$(printf '%s\n' "$result" | tail -n +2 | cut -f1 | grep -v '^$')
  new_tag=""

  if [ -n "$query" ] && ! printf '%s\n' "$all_tags" | grep -qxF "$query"; then
    new_tag="$query"
  fi

  if [ -n "$chosen" ]; then
    muxx tag clear "$session"
    while IFS= read -r tag; do
      [ -n "$tag" ] && muxx tag add "$session" "$tag"
    done <<<"$chosen"
    [ -n "$new_tag" ] && muxx tag add "$session" "$new_tag"
  elif [ -n "$new_tag" ]; then
    muxx tag add "$session" "$new_tag"
  fi
  exit 0
  ;;

--tag-del)
  session="$2"
  data=$(muxx list --json)
  cur_tags=$(printf '%s' "$data" | jq -r --arg s "$session" '.[] | select(.name == $s) | .tags[]')

  [ -z "$cur_tags" ] && exit 0

  _build_color_map "$data"

  lines=""
  while IFS= read -r tag; do
    [ -z "$tag" ] && continue
    c="${TAG_COLORS[$tag]:-90}"
    lines+="${tag}"$'\t'"$(printf '\033[%sm%s\033[0m' "$c" "$tag")"$'\n'
  done <<<"$cur_tags"

  raw=$(printf '%s' "$lines" | fzf \
    --multi \
    --ansi \
    --prompt '  del tag: ' \
    --header "$(printf '\033[90m%s\033[0m  tab=multi-select  enter=delete' "$session")" \
    --delimiter=$'\t' \
    --with-nth=2 \
    --nth=2 \
    --bind 'tab:toggle+up,btab:toggle+down')
  [ $? -eq 130 ] && exit 0

  chosen=$(printf '%s\n' "$raw" | cut -f1 | grep -v '^$')
  [ -z "$chosen" ] && exit 0

  while IFS= read -r tag; do
    [ -n "$tag" ] && muxx tag del "$tag"
  done <<<"$chosen"
  exit 0
  ;;
esac

HEADER=$'\033[90mctrl-n\033[0m new  \033[90mctrl-t\033[0m tags  \033[90mctrl-x\033[0m del tag  \033[90mctrl-r\033[0m rename  \033[90mctrl-d\033[0m kill'

session="$(
  "$SCRIPT" --list |
    fzf-tmux -p 50%,50% \
      --ansi \
      --border-label ' muxx ' \
      --prompt '⚡' \
      --header "$HEADER" \
      --delimiter=$'\t' \
      --with-nth=2 \
      --nth=1 \
      --bind 'tab:up,btab:down' \
      --bind "ctrl-n:execute($SCRIPT --new-session)+reload($SCRIPT --list)" \
      --bind "ctrl-t:execute($SCRIPT --tag-edit {1})+reload($SCRIPT --list)" \
      --bind "ctrl-x:execute($SCRIPT --tag-del {1})+reload($SCRIPT --list)" \
      --bind "ctrl-r:execute($SCRIPT --rename {1})+reload($SCRIPT --list)" \
      --bind "ctrl-d:execute-silent(muxx kill {1})+reload($SCRIPT --list)" |
    cut -f1
)"

[ -z "$session" ] && exit 0

if [ -n "$TMUX" ]; then
  tmux switch-client -t "$session"
else
  tmux attach-session -t "$session"
fi
