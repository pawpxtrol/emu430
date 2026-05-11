#!/usr/bin/env bash
# Run from repo root after: gh auth login
# Creates github.com/pawpatrol/simply-scheme if missing, then pushes main.

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ORG="pawpatrol"
REPO="simply-scheme"
FULL="${ORG}/${REPO}"

if ! command -v gh >/dev/null 2>&1; then
  echo "Install GitHub CLI: brew install gh"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Not logged in. Run this first (pick HTTPS, allow ‘repo’ + workflow scopes):"
  echo "  gh auth login"
  exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote ‘origin’ already set to: $(git remote get-url origin)"
else
  if gh repo view "$FULL" >/dev/null 2>&1; then
    echo "Repo $FULL exists — adding origin and pushing."
    git remote add origin "https://github.com/${FULL}.git"
  else
    echo "Creating $FULL on GitHub and pushing…"
    gh repo create "$FULL" \
      --public \
      --description "EMU430 (Hacettepe) — Paw Patrol — Quarto + R" \
      --source=. \
      --remote=origin \
      --push
    echo "Pushed via gh repo create."
    exit 0
  fi
fi

git push -u origin main
echo "Push complete."

echo ""
echo "Next (GitHub website, org repo ${FULL}):"
echo "  1) Settings → Actions → General → Workflow permissions → Read and write"
echo "  2) Wait for ‘Publish Quarto site’ to finish, then Settings → Pages → Branch: gh-pages / (root)"
echo "  3) Site URL: https://${ORG}.github.io/${REPO}/"
