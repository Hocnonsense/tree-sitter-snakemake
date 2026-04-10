python_scanner="node_modules/tree-sitter-python/src/scanner.c"
snakemake_scanner="src/scanner.c"
patch_file="$snakemake_scanner.diff"

if [ -f "$python_scanner" ]; then
    if [ -f "$snakemake_scanner" ]; then
        tmp="$patch_file.$PPID"
        diff "$python_scanner" "$snakemake_scanner" > "$tmp" || true
        if ! diff -q "$tmp" "$patch_file" > /dev/null 2>&1; then
            echo "WARNING: scanner.c.diff is out of sync, updating"
            mv "$tmp" "$patch_file"
        else
            rm "$tmp"
        fi
    elif [ -f "$patch_file" ]; then
        tmp="$snakemake_scanner.$PPID"
        cp "$python_scanner" "$tmp"
        patch "$tmp" < "$patch_file" &&
            mv "$tmp" "$snakemake_scanner" ||
            { rm -f "$tmp"; echo "ERROR: patch failed"; exit 1; }
    fi
else
    echo "python scanner not found, run npm-install first"
    exit 1
fi
