Example of Neovim setup using tree-sitter-snakemake build from this project.

## Usage
- `.pixi/envs/nvim/bin/nvim`
  Local Neovim executable installed and accessed via `pixi run -e nvim`
- `.nvim-local/bin/clean.sh`
  Removes copied query files and compiled parsers.
- `.nvim-local/bin/build.sh`
  Regenerates highlights, rebuilds parser C sources if needed, recompiles the parser shared libraries, and refreshes the copied query/config/theme files.
- `.nvim-local/bin/nvim-local`
  Starts Neovim from `.pixi/envs/nvim/bin/nvim` using only project-local config/data and the copied project-local runtime.
- `.nvim-local/bin/xdg/`
  Source files for the project-local Neovim config and colorscheme copied by the build script.
