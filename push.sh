#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

bash "$script_dir/update-readme.sh"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf 'This folder is not a git repository. Run: git init -b main\n' >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  printf 'No origin remote found. Add one with: git remote add origin <url>\n' >&2
  exit 1
fi

git add \
  .gitignore \
  .vscode/settings.json \
  generate-progress.py \
  update-readme.sh \
  push.sh \
  progress.svg \
  README.md \
  src

if git diff --cached --quiet; then
  printf 'No changes to commit.\n'
  exit 0
fi

commit_message="${1:-$(date '+%Y-%m-%d') - update solutions}"
git commit -m "$commit_message"

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  branch="main"
fi

git push -u origin "$branch"
