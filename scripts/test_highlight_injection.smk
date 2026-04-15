# Highlight injection test input.
# This file is used by scripts/test_highlight_injection.py, NOT by tree-sitter test
# (which would trigger a cli bug with @variable in injected context).
# It exercises the snakemake_wildcard injection into string_content nodes.

rule wildcard_highlights:
    input: "{sample}.txt"
    output: "{sample}.tsv"
    shell:
        "cat {input:q} > {output}"
        "{input.a} {output.b}"
        "{{escaped}}"
        f"{input:q}"
