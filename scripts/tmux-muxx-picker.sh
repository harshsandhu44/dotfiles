#!/usr/bin/env bash

session="$(
  muxx list --json | jq -r '.[].name' |
    fzf-tmux -p 55%,60% \
      --border-label ' muxx ' \
      --prompt '⚡  ' \
      --header 'Select tmux session' \
      --bind 'tab:down,btab:up' \
      --bind "ctrl-d:execute-silent(tmux kill-session -t {})+reload(muxx list --json | jq -r '.[].name')"
)"

[ -z "$session" ] && exit 0

if [ -n "$TMUX" ]; then
  tmux switch-client -t "$session"
else
  tmux attach-session -t "$session"
fi
