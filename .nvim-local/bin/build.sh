#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCAL_ROOT="$ROOT/.nvim-local"
RUNTIME_DIR="$LOCAL_ROOT/runtime"
CONFIG_DIR="$LOCAL_ROOT/xdg/config/nvim"
PARSER_DIR="$LOCAL_ROOT/xdg/data/nvim/site/parser"

cd "$ROOT"

if [ ! -x "$ROOT/node_modules/.bin/tree-sitter" ]; then
  echo "Missing node_modules/.bin/tree-sitter. Run 'npm ci' first." >&2
  exit 1
fi

mkdir -p "$RUNTIME_DIR/queries/snakemake"
mkdir -p "$RUNTIME_DIR/queries/snakemake_iostr"
mkdir -p "$RUNTIME_DIR/colors"
mkdir -p "$CONFIG_DIR"
mkdir -p "$PARSER_DIR"

node build_tools/queries/update_highlights.cjs
"$ROOT/node_modules/.bin/tree-sitter" generate
(cd "$ROOT/snakemake_iostr" && "$ROOT/node_modules/.bin/tree-sitter" generate)

cc -O2 -fPIC -Isrc -shared src/parser.c src/scanner.c \
  -o "$PARSER_DIR/snakemake.so"

cc -O2 -fPIC -Issnakemake_iostr/src -shared snakemake_iostr/src/parser.c \
  -o "$PARSER_DIR/snakemake_iostr.so"

cp queries/snakemake/folds.scm "$RUNTIME_DIR/queries/snakemake/"
cp queries/snakemake/highlights.scm "$RUNTIME_DIR/queries/snakemake/"
cp queries/snakemake/injections.scm "$RUNTIME_DIR/queries/snakemake/"
cp queries/snakemake/indents.scm "$RUNTIME_DIR/queries/snakemake/"
cp queries/snakemake/locals.scm "$RUNTIME_DIR/queries/snakemake/"
cp snakemake_iostr/queries/highlights.scm "$RUNTIME_DIR/queries/snakemake_iostr/"
cp .nvim-local/bin/xdg/init.lua "$CONFIG_DIR/init.lua"
cp .nvim-local/bin/xdg/colors/snakemake-dark.lua "$RUNTIME_DIR/colors/"

echo "Built parsers into: $PARSER_DIR"
echo "Copied queries into: $RUNTIME_DIR/queries"
echo "Copied config into: $CONFIG_DIR"
echo "Copied colorscheme into: $RUNTIME_DIR/colors"
