#!/usr/bin/env sh
# Link every skill in this repo into a skills folder, so `git pull` updates them.
# Usage: ./install.sh [target]   (default: ~/.claude/skills)
set -eu

repo=$(cd "$(dirname "$0")" && pwd)
target=${1:-"$HOME/.claude/skills"}
mkdir -p "$target"

for dir in "$repo"/skills/*/; do
  name=$(basename "$dir")
  link="$target/$name"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "skip $name: $link already exists and is not a link"
    continue
  fi
  ln -sfn "${dir%/}" "$link"
  echo "linked $name"
done
