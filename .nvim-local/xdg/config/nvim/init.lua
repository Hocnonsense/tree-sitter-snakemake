local uv = vim.uv or vim.loop
local config_dir = vim.fn.stdpath("config")
local local_root = vim.fn.fnamemodify(config_dir, ":h:h:h")
local runtime_dir = local_root .. "/runtime"
local data_dir = vim.fn.stdpath("data") .. "/site/parser"
local theme_dir = local_root .. "/runtime/pack/themes/start/tokyonight.nvim"

vim.opt.runtimepath:prepend(runtime_dir)
vim.opt.packpath:prepend(runtime_dir)
if uv.fs_stat(theme_dir) then
  vim.opt.runtimepath:prepend(theme_dir)
end

vim.filetype.add({
  extension = { smk = "snakemake" },
  filename = {
    ["Snakefile"] = "snakemake",
    ["snakefile"] = "snakemake",
  },
})

local function parser_ext()
  if uv.os_uname().sysname == "Darwin" then
    return "dylib"
  end
  return "so"
end

local function add_parser(lang)
  local parser = string.format("%s/%s.%s", data_dir, lang, parser_ext())
  if uv.fs_stat(parser) then
    vim.treesitter.language.add(lang, { path = parser })
  end
end

add_parser("snakemake")
add_parser("snakemake_iostr")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "snakemake",
  callback = function(args)
    vim.treesitter.start(args.buf, "snakemake")
  end,
})

vim.o.termguicolors = true
vim.o.background = "dark"

local ok = pcall(vim.cmd.colorscheme, "tokyonight-night")
if not ok then
  vim.cmd.colorscheme("snakemake-dark")
end
