#!/usr/bin/env bash
# Creates empty public repo github.com/pawpxtrol/emu430 (org must exist; you must be owner).
# Requires: brew install gh   AND   gh auth login
# Then: bash scripts/create-repo-pawpxtrol.sh

set -euo pipefail
ORG="pawpxtrol"
REPO="emu430"
FULL="${ORG}/${REPO}"

if ! command -v gh >/dev/null 2>&1; then
  echo "Install: brew install gh"
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "Run first: gh auth login"
  exit 1
fi

if gh repo view "${FULL}" >/dev/null 2>&1; then
  echo "Repo ${FULL} already exists."
else
  gh repo create "${FULL}" \
    --public \
    --description "EMU430 (Hacettepe) — Paw Patrol — Quarto + R"
  echo "Created ${FULL}"
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
git remote remove origin 2>/dev/null || true
git remote add origin "git@github.com:${FULL}.git"
echo "Remote origin → git@github.com:${FULL}.git"
echo "Next (same terminal, SSH key must have access to org ${ORG}):"
echo "  ./scripts/git-push-terminal.sh"
echo "If SSH uses the wrong GitHub user, see README → SSH host alias."
