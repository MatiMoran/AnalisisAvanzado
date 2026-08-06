#!/bin/sh
# After cloning this repo from any provider, run:
#   bash scripts/setup-remotes.sh
# It reconfigures `origin` so that fetch comes from GitHub (primary) and
# `git push` pushes to both GitHub and GitLab for redundancy.

set -euo pipefail

GITHUB_URL="git@github.com:MatiMoran/AnalisisAvanzado.git"
GITLAB_URL="git@gitlab.com:MatiMoran/AnalisisAvanzado.git"

if git remote get-url origin >/dev/null 2>&1; then
  git remote remove origin
fi

git remote add origin "$GITHUB_URL"
git remote set-url --add --push origin "$GITHUB_URL"
git remote set-url --add --push origin "$GITLAB_URL"

echo "Remotes configured:"
git remote -v
