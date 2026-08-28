#!/usr/bin/env bash

set -euo pipefail

selected=$(
  find "$HOME/repos" -mindepth 1 -maxdepth 1 -type d ! -name '.*' | \
    sort | \
    fzf --prompt='Project: ' --preview='ls -la {}'
)

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
