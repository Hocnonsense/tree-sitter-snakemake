#!/usr/bin/env python3
"""
Highlight injection snapshot test.

Verifies that the snakemake_iostr grammar is correctly injected into
string_content nodes by the snakemake grammar, producing the expected
highlight captures.

Uses `tree-sitter highlight --html` with a custom theme that assigns
unique colors to each capture type.  This code path is identical to what
editors (Neovim, Helix) use, unlike `tree-sitter test` which has a known
CLI bug with @variable captures from injected grammars.

Run:  pytest tests/test_highlight_injection.py
"""

import re
import subprocess
import sys
from pathlib import Path
import json

REPO = Path(__file__).resolve().parent.parent
THEME = REPO / "tests/test_highlight_theme.json"
with THEME.open() as f:
    COLOR_TO_CAPTURE = {k["color"]: v for v, k in json.load(f)["theme"].items()}


def get_highlights(smk_file: Path, theme_file: Path):
    """Return list of (text, capture_name) for every highlighted span."""
    result = subprocess.run(
        [
            "tree-sitter",
            "highlight",
            "--html",
            "--config-path",
            str(theme_file),
            str(smk_file),
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print("tree-sitter highlight failed:", result.stderr, file=sys.stderr)
        sys.exit(1)

    highlights: list[tuple[str, str]] = []
    for m in re.finditer(r"<span style='([^']+)'>([^<]+)</span>", result.stdout):
        style, raw = m.group(1), m.group(2)
        text = (
            raw.replace("&quot;", '"')
            .replace("&amp;", "&")
            .replace("&gt;", ">")
            .replace("&lt;", "<")
        )
        color = re.search(r"#[0-9a-f]{6}", style)
        if color and (capture := COLOR_TO_CAPTURE.get(color.group())):
            highlights.append((text, capture))
    return highlights


def test_wildcards():
    test_file = REPO / "tests/test_highlight_injection.smk"
    highlights = get_highlights(test_file, THEME)

    def expect(text: str, capture: str) -> None:
        actual = {c for t, c in highlights if t == text} or {"unhighlighted"}
        assert capture in actual, f"'{text}' should be @{capture} (got: {actual})"

    def expect_not(text: str, capture: str) -> None:
        actual = {c for t, c in highlights if t == text} or {"unhighlighted"}
        assert (
            capture not in actual
        ), f"'{text}' should NOT be @{capture} (got: {actual})"

    # --- wildcard definitions (input/output directives) ---
    # {sample} in plain strings → @variable (user-defined wildcard name)
    expect("sample", "variable")

    # --- wildcard interpolations (shell directive) ---
    # {input:q} → name=input (@label), flag=q (@variable.parameter.builtin)
    expect("input", "label")
    expect("q", "variable.parameter.builtin")

    # {output} → @label (directive reference)
    expect("output", "label")

    # {input.a}, {output.b} → whole dotted name is @label
    expect("input.a", "label")
    expect("output.b", "label")

    # --- escaped braces ---
    # {{...}} → @string.escape for each {{ and }}
    expect("{{", "string.escape")
    expect("}}", "string.escape")

    # --- f-strings are NOT injected ---
    # f"{input:q}" uses Python interpolation, not snakemake_iostr;
    # "input" inside is an identifier, not a wildcard name → no @label from injection
    # (the directive keyword "input:" above produces a separate @label entry,
    #  but f-string content should not add another one beyond what the main grammar sees)
    # This is verified indirectly: no @variable.parameter.builtin from f-string "q"
    # since f-string {input:q} parses "q" as a format_spec, not a wildcard flag.
    # We check that "q" only appears once (from the plain-string {input:q}).
    q_captures = [(t, c) for t, c in highlights if t == "q"]
    assert len(q_captures) == 1, (
        f"  FAIL  'q' should appear exactly once as @variable.parameter.builtin"
        f" (got {q_captures})"
    )
    print(f"highlight injection tests passed  ({len(highlights)} highlighted spans)")
