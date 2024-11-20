if vim.g.vscode then
	print("VSCode Extension")
else
	print("Ordinary Neovim")
end

vim.lsp.set_log_level("off")
require("core.options")
require("core.keymaps")
require("lazy-setup")
require("core.autocommands")
vim.o.background = "light"
vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd([[:hi SignColumn guibg=None]])
-- vim.cmd([[:hi Comment guifg=#7a7a7a]])

-- Turn it off with vim.lsp.set_log_level("off")
-- and when you need it for debugging, switch it to vim.lsp.set_log_level("debug").
