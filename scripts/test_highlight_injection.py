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

Run:  python scripts/test_highlight_injection.py
"""

import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
THEME = REPO / "scripts/test_highlight_theme.json"
TEST_FILE = REPO / "scripts/test_highlight_injection.smk"

COLOR_TO_CAPTURE = {
    "#aa0000": "variable",
    "#bb0000": "variable.builtin",
    "#cc0000": "variable.parameter.builtin",
    "#00aa00": "label",
    "#0000aa": "string.escape",
    "#aa00aa": "keyword",
    "#00aaaa": "type",
}


def get_highlights(smk_file: Path, theme_file: Path) -> list[tuple[str, str]]:
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

    highlights = []
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


def run_tests(highlights: list[tuple[str, str]]) -> bool:
    failures = []

    def expect(text: str, capture: str) -> None:
        actual = {c for t, c in highlights if t == text}
        if capture not in actual:
            failures.append(
                f"  FAIL  '{text}' -> @{capture}  (got: {actual or 'unhighlighted'})"
            )

    def expect_not(text: str, capture: str) -> None:
        actual = {c for t, c in highlights if t == text}
        if capture in actual:
            failures.append(f"  FAIL  '{text}' should NOT be @{capture}")

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
    if len(q_captures) != 1:
        failures.append(
            f"  FAIL  'q' should appear exactly once as @variable.parameter.builtin"
            f" (got {q_captures})"
        )

    if failures:
        print("highlight injection tests FAILED:")
        print("\n".join(failures))
        return False

    print(f"highlight injection tests passed  ({len(highlights)} highlighted spans)")
    return True


if __name__ == "__main__":
    highlights = get_highlights(TEST_FILE, THEME)
    sys.exit(0 if run_tests(highlights) else 1)
