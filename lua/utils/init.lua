local M = {}

M.servers = {
	"cssls",
	"html",
	"ts_ls",
	"eslint",
	"bashls",
	"jsonls",
	"yamlls",
	"tailwindcss",
	"emmet_ls",
	"ruff",
	"cmake",
}

M.lservers = {
	"jedi_language_server",
	"clangd",
	"pyright",
	"rust_analyzer",
}

M.linters = {
	"prettier",
	"stylua",
}

M.parsers = {
	"lua",
	"vim",
	"markdown",
	"markdown_inline",
	"bash",
	"cpp",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"json",
	"yaml",
	"toml",
	"regex",
}

return M
