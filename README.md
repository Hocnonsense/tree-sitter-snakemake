# tree-sitter-snakemake

[![CI](https://github.com/osthomas/tree-sitter-snakemake/workflows/CI/badge.svg)](https://github.com/osthomas/tree-sitter-snakemake/actions)

A tree-sitter grammar for
[Snakemake](https://snakemake.readthedocs.io/en/stable/),
a workflow management system.

Snakemake is an extension of Python, and tree-sitter-snakemake is an extension
of [tree-sitter-python](https://github.com/tree-sitter/tree-sitter-python).

## Development

[pixi](https://pixi.sh) is used to manage the development environment.

This `build` branch is the maintenance branch used to generate the compact `main` branch.
It keeps build-only inputs and tools under `build_tools/`, plus the local Neovim example under `.nvim-local/` and CI workflows.
On every push to `build`, GitHub Actions regenerates the tree-sitter outputs, removes the "build-only" section, and opens or updates a PR against `main`.

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

## Syncing with Snakemake

Directive keywords and highlight keyword lists for [Snakemake](https://snakemake.readthedocs.io/en/stable/) are kept in separate JSON files, so most synchronization work can be done by editing them only, without touching the grammar or query source files.

- `directives.json`: source of truth for grammar-level directive names and statement groupings.
  Read directly by `grammar.js`.
- `highlights.json`: source of truth for highlight keyword lists (builtin objects, job parameter objects, helper functions, classes).
  Used to generate `queries/snakemake/highlights.scm` from `build_tools/queries/highlights.template.scm`.
- `build_tools/queries/update_highlights.js`: combines the hand-written query template with the directive and highlight JSON data.
  It writes and checks the editor-ready `queries/snakemake/highlights.scm`.

When Snakemake adds, removes, or renames directives, update these JSON data files to reflect the changes.
Run `pixi run build` or `pixi run clean-tests` to apply changes.
