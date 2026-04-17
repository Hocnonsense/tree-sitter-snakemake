#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCAL_ROOT="$ROOT/.nvim-local"
THEME_DIR="$LOCAL_ROOT/runtime/pack/themes/start/tokyonight.nvim"
THEME_URL="https://github.com/folke/tokyonight.nvim.git"

mkdir -p "$(dirname "$THEME_DIR")"

if [ -d "$THEME_DIR/.git" ]; then
  echo "Updating tokyonight theme..."
  git -C "$THEME_DIR" pull --ff-only
else
  echo "Cloning tokyonight theme into project-local runtime..."
  git clone --depth=1 "$THEME_URL" "$THEME_DIR"
fi

echo "Tokyonight installed at: $THEME_DIR"
