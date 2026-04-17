snakemake_scanner="src/scanner.c"

# Ensure all tree_sitter_python_* symbols have been renamed.
# If upstream adds new external scanner functions, the diff must rename them too.
if grep -q 'tree_sitter_python_' "$snakemake_scanner"; then
    echo "ERROR: scanner.c still contains unrenamed tree_sitter_python_* symbols"
    echo "       upstream may have added new external scanner functions - update the diff"
    grep -n 'tree_sitter_python_' "$snakemake_scanner"
    exit 1
fi

# Ensure src/scanner.c is in sync with tree-sitter-python,
# except for the expected modifications in the diff.
python_scanner="node_modules/tree-sitter-python/src/scanner.c"
patch_file="$snakemake_scanner.diff"

tmp="$patch_file.check.$PPID"
diff "$python_scanner" "$snakemake_scanner" > "$tmp" || true
if ! diff -q "$tmp" "$patch_file" > /dev/null 2>&1; then
    echo "ERROR: src/scanner.c is out of sync with src/scanner.c.diff"
    diff "$patch_file" "$tmp"
    exit 1
fi
rm "$tmp"
