#!/usr/bin/env bash
# Use this when Cursor's Git integration returns 401 (bad GIT_ASKPASS).
# Run in Terminal.app (or iTerm), NOT the Cursor-embedded terminal if that still fails.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Stop Cursor / VS Code from intercepting Git credentials over HTTPS
unset GIT_ASKPASS SSH_ASKPASS
export GIT_TERMINAL_PROMPT=1

echo "Remote: $(git remote get-url origin)"
echo "Pushing main…"
git push -u origin main
echo "Done."
