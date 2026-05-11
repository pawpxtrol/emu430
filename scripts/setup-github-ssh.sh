#!/usr/bin/env bash
# One-time: create SSH key for GitHub, add to agent + Keychain, print pubkey to paste on GitHub.
# Run in Terminal.app:  bash scripts/setup-github-ssh.sh

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEY="${HOME}/.ssh/id_ed25519_github"
PUB="${KEY}.pub"
CONFIG="${HOME}/.ssh/config"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"
[[ -f "$CONFIG" ]] || touch "$CONFIG"
chmod 600 "$CONFIG"

if [[ ! -f "$KEY" ]]; then
  echo "Creating new key: $KEY"
  ssh-keygen -t ed25519 -C "github-pawpatrol" -f "$KEY" -N ""
else
  echo "Using existing key: $KEY"
fi

MARKER="# EMU430 github.com (id_ed25519_github)"
if ! grep -qF "$MARKER" "$CONFIG" 2>/dev/null; then
  {
    echo ""
    echo "$MARKER"
    echo "Host github.com"
    echo "  HostName github.com"
    echo "  User git"
    echo "  IdentityFile $KEY"
    echo "  AddKeysToAgent yes"
    echo "  UseKeychain yes"
  } >> "$CONFIG"
  echo "Updated $CONFIG"
fi

eval "$(ssh-agent -s)"
if ssh-add --apple-use-keychain "$KEY" 2>/dev/null; then
  echo "Key added to ssh-agent (macOS Keychain)."
else
  ssh-add "$KEY"
  echo "Key added to ssh-agent."
fi

echo ""
echo "=== Copy the single line below into GitHub → SSH keys ==="
cat "$PUB"
echo ""
echo "=== https://github.com/settings/keys → New SSH key ==="
echo ""
echo "Then:"
echo "  ssh -T git@github.com"
echo "  cd $ROOT && ./scripts/git-push-terminal.sh"
