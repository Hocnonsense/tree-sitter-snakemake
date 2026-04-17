Example of Neovim setup using tree-sitter-snakemake build from this project.

## Useage
- `.pixi/envs/nvim/bin/nvim`
  Local Neovim executable installed and accessed via `pixi run -e nvim`
- `.nvim-local/bin/clean.sh`
  Removes copied query files and compiled parsers, while preserving `runtime/pack/` so downloaded themes do not need to be fetched again.
- `.nvim-local/bin/build.sh`
  Regenerates highlights, rebuilds parser C sources if needed, recompiles the parser shared libraries, refreshes the copied query files, and installs/updates the project-local `tokyonight` theme.
  - `.nvim-local/bin/install-theme.sh`
    Download `tokyonight.nvim` into the project-local runtime.
- `.nvim-local/bin/nvim-local`
  Starts Neovim from `.pixi/envs/nvim/bin/nvim` using only project-local config/data and the copied project-local runtime.
