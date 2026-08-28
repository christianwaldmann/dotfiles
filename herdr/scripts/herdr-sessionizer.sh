#!/usr/bin/env bash

set -euo pipefail

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(
    find "$HOME/repos" "$HOME" -mindepth 1 -maxdepth 1 -type d | \
      sed "s|^$HOME/||" | \
      fzf
  )

  if [[ -n $selected ]]; then
    selected="$HOME/$selected"
  fi
fi

[[ -n $selected ]] || exit 0

label=$(basename "$selected" | tr . _)
workspace_id=$(
  herdr workspace list | \
    jq -r --arg label "$label" \
      '.result.workspaces[] | select(.label == $label) | .workspace_id' | \
    head -n 1
)

if [[ -n $workspace_id ]]; then
  herdr workspace focus "$workspace_id"
else
  herdr workspace create --cwd "$selected" --label "$label" --focus
fi
