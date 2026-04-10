python_scanner="node_modules/tree-sitter-python/src/scanner.c"
snakemake_scanner="src/scanner.c"
patch_file="$snakemake_scanner.diff"
tmp="$patch_file.check.$PPID"

diff "$python_scanner" "$snakemake_scanner" > "$tmp" || true
if ! diff -q "$tmp" "$patch_file" > /dev/null 2>&1; then
    echo "ERROR: src/scanner.c is out of sync with src/scanner.c.diff"
    diff "$patch_file" "$tmp"
    exit 1
fi
rm "$tmp"
