vim.g.mapleader = " "

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { noremap = true, silent = true })
-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Map leader keys
vim.g.mapleader = " "
vim.b.maplocalleader = ";"

------------- Normal Mode -------------
-- Better move around
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Better Window Navigation
-- Window Keymap
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- Buffer keymap
keymap("n", "<C-H>", "<C-W><C-H>", opts)
keymap("n", "<C-J>", "<C-W><C-J>", opts)
keymap("n", "<C-K>", "<C-W><C-K>", opts)
keymap("n", "<C-L>", "<C-W><C-L>", opts)

-- Better search and highlight
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "*", "*zzzv", opts)
keymap("n", "#", "#zzzv", opts)
keymap("n", "<esc>", "<cmd>noh<cr>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)
keymap("n", "x", '"_x', opts)
keymap("n", "X", '"_X', opts)
keymap("n", "<leader>P", '"*p', opts)
keymap("v", "<leader>y", '"*y', opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Delete buffer
keymap("n", "<leader>x", "<cmd>bdelete<CR>")

-- Clear highlights
keymap("n", "<leader>h", vim.cmd.nohlsearch, opts)

-- Netrw File Explorer
keymap("n", "<leader>.", "<cmd>Sex<CR>", opts)

-- Make current file executable
keymap("n", "<leader><leader>x", "<cmd>!chmod +x %<cr>")

------------- Insert Mode -------------
-- Delete whole word backward
keymap("i", "<C-BS>", "<C-W>", opts)

------------- Visual Mode -------------
-- Stay in indent mode
keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)

-- Alt Normal --
keymap("n", "<A-j>", "<cmd>mo +1<CR>", opts)
keymap("n", "<A-k>", "<cmd>mo -2<CR>", opts)

-- Focus windows --
keymap("n", "<A-w>", "<C-w>w")

-- Set quickfixlist (insert diagnostic) --
keymap("n", "<leader>qs", vim.diagnostic.setqflist)
