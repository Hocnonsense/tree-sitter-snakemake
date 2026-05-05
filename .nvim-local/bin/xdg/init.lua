local uv = vim.uv or vim.loop
local config_dir = vim.fn.stdpath("config")
local local_root = vim.fn.fnamemodify(config_dir, ":h:h:h")
local runtime_dir = local_root .. "/runtime"
local data_dir = vim.fn.stdpath("data") .. "/site/parser"

vim.opt.runtimepath:prepend(runtime_dir)
vim.opt.packpath:prepend(runtime_dir)

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
vim.cmd.colorscheme("snakemake-dark")
