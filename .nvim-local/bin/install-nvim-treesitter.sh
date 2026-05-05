#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCAL_ROOT="$ROOT/.nvim-local"
PLUGIN_DIR="$LOCAL_ROOT/runtime/pack/plugins/start/nvim-treesitter"
PLUGIN_URL="https://github.com/nvim-treesitter/nvim-treesitter.git"

mkdir -p "$(dirname "$PLUGIN_DIR")"

if [ -d "$PLUGIN_DIR/.git" ]; then
  echo "Updating nvim-treesitter..."
  git -C "$PLUGIN_DIR" pull --ff-only
else
  echo "Cloning nvim-treesitter into project-local runtime..."
  git clone --depth=1 "$PLUGIN_URL" "$PLUGIN_DIR"
fi

echo "nvim-treesitter installed at: $PLUGIN_DIR"
