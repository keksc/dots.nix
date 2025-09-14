#!/usr/bin/env bash

# Start with initial workspace state (compact)
workspaces=$(niri msg -j workspaces | jq -c '.')

# Output the initial state
echo "$workspaces"

# Listen to the event stream
niri msg -j event-stream | while read -r line; do
    # Handle WorkspaceActivated events
    activated=$(jq -r 'select(.WorkspaceActivated) | .WorkspaceActivated.id' <<<"$line")
    if [[ -n "$activated" ]]; then
        # Update the is_active field in the cached array
        workspaces=$(jq -c --arg id "$activated" 'map(.is_active = (.id == ($id|tonumber)))' <<<"$workspaces")
        echo "$workspaces"
    fi

    # Handle WorkspacesChanged (e.g., on startup or workspace creation)
    changed=$(jq -c 'select(.WorkspacesChanged) | .WorkspacesChanged.workspaces' <<<"$line")
    if [[ -n "$changed" ]]; then
        workspaces="$changed"
        echo "$workspaces"
    fi
done
