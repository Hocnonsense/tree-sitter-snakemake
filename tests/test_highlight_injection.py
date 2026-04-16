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
from html.parser import HTMLParser
from tempfile import NamedTemporaryFile
import subprocess
import json

COLOR_TO_CAPTURE = {
    "#aa0000": "variable",
    "#bb0000": "variable.builtin",
    "#cc0000": "variable.parameter.builtin",
    "#00aa00": "label",
    "#0000aa": "string.escape",
    "#aa00aa": "keyword",
    "#00aaaa": "type",
}
COLOR_TO_THEME = {"theme": {v: {"color": k} for k, v in COLOR_TO_CAPTURE.items()}}


class HighlightHTMLParser(HTMLParser):
    """Extract (text, capture_name) tuples from tree-sitter HTML output."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[tuple[str, str]] = []
        self._capture_stack = [""]
        self._in_body = False
        self._in_table = False
        self._in_line_cell = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]):
        attr_map = dict(attrs)

        if tag == "body":
            self._in_body = True
            return
        if tag == "table" and self._in_body:
            self._in_table = True
            return
        if tag == "td" and self._in_table:
            self._in_line_cell = attr_map.get("class") == "line"
            return
        if tag == "span" and self._in_line_cell:
            style = attr_map.get("style", "") or ""
            self._capture_stack.append(self._capture_from_style(style))

    def handle_endtag(self, tag: str):
        if tag == "span" and self._in_line_cell and len(self._capture_stack) > 1:
            self._capture_stack.pop()
            return
        if tag == "td" and self._in_table:
            self._in_line_cell = False
            return
        if tag == "table":
            self._in_table = False
            return
        if tag == "body":
            self._in_body = False

    def handle_data(self, data: str):
        if self._in_line_cell and data:
            self.parts.append((data, self._capture_stack[-1]))

    def _capture_from_style(self, style: str):
        color = re.search(r"#[0-9a-fA-F]{6}", style)
        if not color:
            return ""
        return color.group().lower()


def get_highlights(snakecode: str):
    """Return ordered (text, capture_name_or_empty) tuples from highlighted HTML."""
    with (
        NamedTemporaryFile("w", suffix=".json", delete=False) as tmptheme,
        NamedTemporaryFile("w", suffix=".smk", delete=False) as tmpsmk,
    ):
        tmpsmk.write(snakecode)
        tmpsmk.flush()
        tmptheme.write(json.dumps(COLOR_TO_THEME))
        tmptheme.flush()
        result = subprocess.run(
            [
                "tree-sitter",
                "highlight",
                "--html",
                "--config-path",
                str(tmptheme.name),
                str(tmpsmk.name),
            ],
            capture_output=True,
            text=True,
        )
    assert result.returncode == 0, f"tree-sitter highlight failed: {result.stderr}"

    html_parser = HighlightHTMLParser()
    html_parser.feed(result.stdout)
    html_parser.close()
    return [(s, COLOR_TO_CAPTURE.get(l, "")) for s, l in html_parser.parts]


def test_rule_and_direvtives():
    example = (
        "rule ruleA:\n"
        "    # comment\n"
        '    input: a = "b",\n'
        '        b = "c",\n'
        '        c = "{sample}.txt",\n'
        '    output: "{sample}.tsv",\n'
        "# comment\n"
        "        # comment\n"
        '        d = "d"\n'
        "    shell:\n"
        "#   ^^^^^ label\n"
        '        "cat {input:q} > {output.d:q}"\n'
        '        f"{input:d}"\n'
        '        "{input}"\n'
        "    run:\n"
        "        threads + 5\n"
        "#       ^^^^^^^ label\n"
    )
    highlights = get_highlights(example)
    assert highlights == [
        *(("rule", "keyword"), (" ", ""), ("ruleA", "type"), (":\n", "")),
        ("    # comment\n", ""),
        ("    ", ""),
        *(("input", "label"), (': a = "b",\n', ""), ('        b = "c",\n', "")),
        *(('        c = "{', ""), ("sample", "variable"), ('}.txt",\n', "")),
        ("    ", ""),
        *(("output", "label"), (': "{', ""), ("sample", "variable"), ('}.tsv",\n', "")),
        ("# comment\n", ""),
        ("        # comment\n", ""),
        ('        d = "d"\n', ""),
        ("    ", ""),
        *(("shell", "label"), (":\n", ""), ("#   ^^^^^ label\n", "")),
        *(('        "cat {', ""), ("input", "label"), (":", "")),
        ("q", "variable.parameter.builtin"),
        *(("} > {", ""), ("output.d", "label"), (":", "")),
        ("q", "variable.parameter.builtin"),
        *(('}"\n', ""), ('        f"{', ""), ("input", "label"), (':d}"\n', "")),
        *(('        "{', ""), ("input", "label"), ('}"\n', "")),
        *(("    ", ""), ("run", "label"), (":\n", "")),
        *(("        ", ""), ("threads", "label"), (" + 5\n", "")),
        ("#       ^^^^^^^ label\n", ""),
    ]


def test_wildcards():
    example = (
        "rule wildcard_highlights:\n"
        '    input: "{sample}.txt"\n'
        '    output: "{sample}.tsv"\n'
        "    shell:\n"
        '        "cat {input:q} > {output}"\n'
        '        "{input.a} {output.b}"\n'
        '        "{{escaped}}"\n'
        '        f"{input:q}"\n'
    )
    highlights = get_highlights(example)
    assert highlights == [
        *(("rule", "keyword"), (" ", ""), ("wildcard_highlights", "type"), (":\n", "")),
        *(("    ", ""), ("input", "label")),
        *((': "{', ""), ("sample", "variable"), ('}.txt"\n', "")),
        *(("    ", ""), ("output", "label")),
        *((': "{', ""), ("sample", "variable"), ('}.tsv"\n', "")),
        *(("    ", ""), ("shell", "label"), (":\n", "")),
        *(('        "cat {', ""), ("input", "label"), (":", "")),
        ("q", "variable.parameter.builtin"),
        *(("} > {", ""), ("output", "label"), ('}"\n', "")),
        *(('        "{', ""), ("input.a", "label"), ("} {", "")),
        *(("output.b", "label"), ('}"\n', "")),
        *(('        "', ""), ("{{", "string.escape"), ("escaped", "")),
        *(("}}", "string.escape"), ('"\n', "")),
        *(('        f"{', ""), ("input", "label"), (':q}"\n', "")),
    ]
