#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCAL_ROOT="$ROOT/.nvim-local"

# Keep runtime/pack so downloaded themes/plugins do not need to be fetched again.
rm -rf "$LOCAL_ROOT/runtime/queries"
rm -rf "$LOCAL_ROOT/runtime/colors"
rm -rf "$LOCAL_ROOT/xdg/config"
rm -rf "$LOCAL_ROOT/xdg/data"
rm -rf "$LOCAL_ROOT/xdg/state"
rm -rf "$LOCAL_ROOT/xdg/cache"

mkdir -p "$LOCAL_ROOT/runtime"
mkdir -p "$LOCAL_ROOT/xdg/config"
mkdir -p "$LOCAL_ROOT/xdg/data"
