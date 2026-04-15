# tree-sitter-snakemake

[![CI](https://github.com/Hocnonsense/tree-sitter-snakemake/workflows/CI/badge.svg)](https://github.com/Hocnonsense/tree-sitter-snakemake/actions)

A tree-sitter grammar for
[snakemake](https://snakemake.readthedocs.io/en/stable/),
a workflow management system.

Snakemake is an extension of Python, and tree-sitter-snakemake is an extension
of [tree-sitter-python](https://github.com/tree-sitter/tree-sitter-python).

## Development

[pixi](https://pixi.sh) is used to manage the development environment.

Run `pixi run build` to generate files (`src/parser.c`, `bindings/{python,rust,go}/*`, `Cargo.toml`, etc.) for binding to other languages.
Files under version control (e.g., `src/scanner.c`, `pyproject.toml`) will not be overwritten.
Run `pixi run clean` to remove these automatically generated files.

Run `pixi run tests` to quickly test if changes work, and `pixi run clean-tests` to regenerate from scratch and test.

To update the `tree-sitter-python` dependency:
```bash
pixi run --environment build npm install tree-sitter-python@latest
# or update al dependencies
pixi run --environment build npm install
```
