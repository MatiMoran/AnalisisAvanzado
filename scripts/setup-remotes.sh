#!/bin/sh
# After cloning this repo from any provider, run:
#   bash scripts/setup-remotes.sh
# It reconfigures `origin` so that fetch comes from GitHub (primary) and
# `git push` pushes to both GitHub and GitLab for redundancy, and sets
# upstream tracking for every local branch that exists on origin.

set -euo pipefail

GITHUB_URL="git@github.com:MatiMoran/AnalisisAvanzado.git"
GITLAB_URL="git@gitlab.com:MatiMoran/AnalisisAvanzado.git"

if git remote get-url origin >/dev/null 2>&1; then
  git remote remove origin
fi

if git remote get-url gitlab >/dev/null 2>&1; then
  git remote remove gitlab
fi

git remote add origin "$GITHUB_URL"
git remote set-url --add --push origin "$GITHUB_URL"
git remote set-url --add --push origin "$GITLAB_URL"

# Removing origin wipes refs/remotes/origin/*; refetch so tracking refs exist.
git fetch origin --prune

# Set upstream tracking for every local branch that exists on origin.
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
  if git rev-parse --quiet --verify "refs/remotes/origin/$branch" >/dev/null; then
    git branch --set-upstream-to="origin/$branch" "$branch"
  else
    echo "WARN: branch '$branch' has no origin/$branch; leaving it untracked"
  fi
done

echo "Remotes configured:"
git remote -v
