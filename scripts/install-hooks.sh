#!/usr/bin/env bash
# Enable the versioned git hooks of this repo and set the anonymous commit email (local to this repo only).
#   scripts/install-hooks.sh <id>+<user>@users.noreply.github.com
# Without the argument, an address already set in this repo's local config is kept.
set -eu
cd "$(git rev-parse --show-toplevel)"
chmod +x .githooks/pre-commit scripts/check-secrets.sh
git config core.hooksPath .githooks

email=${1:-$(git config --local user.email || true)}
case "$email" in
  *@users.noreply.github.com) ;;
  *) echo "Pass the GitHub noreply address as argument (GitHub > Settings > Emails)." >&2; exit 1 ;;
esac
git config --local user.email "$email"
git config --local user.name "$(git config user.name || echo davidemark)"
echo "hooks enabled (core.hooksPath=.githooks), commit email set for this repo"
