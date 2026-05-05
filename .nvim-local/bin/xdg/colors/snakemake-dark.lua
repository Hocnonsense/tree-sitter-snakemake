-- Snakemake dark colorscheme
-- Designed to highlight Snakemake-specific tree-sitter captures clearly.

vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "snakemake-dark"
vim.o.background = "dark"

local hi = vim.api.nvim_set_hl

-- Palette
local c = {
  bg        = "#1e2127",
  bg1       = "#282c34",
  bg2       = "#31353f",
  fg        = "#abb2bf",
  fg_dim    = "#5c6370",
  red       = "#e06c75",
  orange    = "#d19a66",
  yellow    = "#e5c07b",
  green     = "#98c379",
  cyan      = "#56b6c2",
  blue      = "#61afef",
  purple    = "#c678dd",
  comment   = "#5c6370",
  white     = "#dcdfe4",
}

-- Editor base
hi(0, "Normal",        { fg = c.fg,      bg = c.bg })
hi(0, "NormalFloat",   { fg = c.fg,      bg = c.bg2 })
hi(0, "LineNr",        { fg = c.fg_dim })
hi(0, "CursorLine",    { bg = c.bg1 })
hi(0, "CursorLineNr",  { fg = c.yellow,  bold = true })
hi(0, "Visual",        { bg = c.bg2 })
hi(0, "Search",        { fg = c.bg,      bg = c.yellow })
hi(0, "IncSearch",     { fg = c.bg,      bg = c.orange })
hi(0, "StatusLine",    { fg = c.fg,      bg = c.bg2 })
hi(0, "StatusLineNC",  { fg = c.fg_dim,  bg = c.bg1 })
hi(0, "VertSplit",     { fg = c.bg2 })
hi(0, "Pmenu",         { fg = c.fg,      bg = c.bg2 })
hi(0, "PmenuSel",      { fg = c.white,   bg = c.blue })
hi(0, "SignColumn",    { bg = c.bg })
hi(0, "ColorColumn",   { bg = c.bg1 })
hi(0, "MatchParen",    { fg = c.yellow,  bold = true, underline = true })

-- Syntax base (non-TS fallback)
hi(0, "Comment",       { fg = c.comment, italic = true })
hi(0, "Constant",      { fg = c.cyan })
hi(0, "String",        { fg = c.green })
hi(0, "Character",     { fg = c.green })
hi(0, "Number",        { fg = c.orange })
hi(0, "Boolean",       { fg = c.orange })
hi(0, "Identifier",    { fg = c.fg })
hi(0, "Function",      { fg = c.blue })
hi(0, "Keyword",       { fg = c.purple,  bold = true })
hi(0, "Operator",      { fg = c.cyan })
hi(0, "Type",          { fg = c.yellow })
hi(0, "Special",       { fg = c.cyan })
hi(0, "Delimiter",     { fg = c.fg_dim })
hi(0, "Error",         { fg = c.red,     bold = true })
hi(0, "Todo",          { fg = c.yellow,  bold = true })

-- Tree-sitter standard captures
hi(0, "@comment",                    { link = "Comment" })
hi(0, "@string",                     { link = "String" })
hi(0, "@string.escape",              { fg = c.cyan })
hi(0, "@number",                     { link = "Number" })
hi(0, "@boolean",                    { link = "Boolean" })
hi(0, "@keyword",                    { fg = c.purple, bold = true })
hi(0, "@keyword.import",             { fg = c.purple, italic = true })
hi(0, "@keyword.return",             { fg = c.purple, italic = true })
hi(0, "@operator",                   { link = "Operator" })
hi(0, "@type",                       { fg = c.yellow })
hi(0, "@type.builtin",               { fg = c.yellow, italic = true })
hi(0, "@variable",                   { fg = c.orange })
hi(0, "@variable.builtin",           { fg = c.red, italic = true })
hi(0, "@variable.parameter",         { fg = c.orange })
hi(0, "@variable.parameter.builtin", { fg = c.cyan, italic = true })
hi(0, "@function",                   { fg = c.blue })
hi(0, "@function.builtin",           { fg = c.cyan, bold = true })
hi(0, "@function.call",              { fg = c.blue })
hi(0, "@method",                     { fg = c.blue })
hi(0, "@field",                      { fg = c.fg })
hi(0, "@property",                   { fg = c.fg })
hi(0, "@punctuation.bracket",        { fg = c.fg_dim })
hi(0, "@punctuation.delimiter",      { fg = c.fg_dim })

-- @label: Snakemake subordinate directives (input:, output:, params:, etc.)
hi(0, "@label", { fg = c.green, bold = true })

-- Diagnostics
hi(0, "DiagnosticError", { fg = c.red })
hi(0, "DiagnosticWarn",  { fg = c.yellow })
hi(0, "DiagnosticInfo",  { fg = c.blue })
hi(0, "DiagnosticHint",  { fg = c.cyan })
