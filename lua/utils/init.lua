local M = {}

M.servers = {
	"cssls",
	"html",
	"ts_ls",
	"bashls",
	"tailwindcss",
	"emmet_ls",
	"ruff",
	"cmake",
	"lua_ls",
}

M.lservers = {
	"jedi_language_server",
	"clangd",
	"pyright",
	"rust_analyzer",
	"gopls",
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
