vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Briefly highlight yanked text",
})

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
--   callback = function()
--     vim.cmd([[
--       nnoremap <silent> <buffer> q :close<CR>
--       set nobuflisted
--     ]])
--   end,
-- })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

function GetOS()
  return package.config:sub(1, 1) == "\\" and "win" or "unix"
end

if GetOS() == "win" then
  vim.api.nvim_create_autocmd({ "BufNewFile", "TabEnter", "BufEnter" }, {
    pattern = { "*.cpp" },
    -- command = "0r ~/.config/nvim/skeletons/skeleton.cpp",
    callback = function()
      vim.keymap.set("n", "<leader>im", "<cmd>:r C:/Users/Sahil/AppData/Local/nvim/skeletons/cpp/main.cpp<CR>")
      vim.keymap.set("n", "<leader>if", "<cmd>:r C:/Users/Sahil/AppData/Local/nvim/skeletons/cpp/fastio.cpp<CR>")
    end,
  })
else
  vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = { "*.cpp" },
    command = "0r ~/.config/nvim/skeletons/cpp/main.cpp",
  })
  vim.api.nvim_create_autocmd({ "BufNewFile", "TabEnter", "BufEnter" }, {
    pattern = { "*.cpp" },
    callback = function()
      vim.keymap.set("n", "<leader>im", "<cmd>:r /home/taarkik/.config/nvim/skeletons/cpp/main.cpp<CR>")
      vim.keymap.set("n", "<leader>if", "<cmd>:r /home/taarkik/.config//nvim/skeletons/cpp/fastio.cpp<CR>")
      vim.keymap.set("n", "<leader>ic", "<cmd>:r /home/taarkik/.config/nvim/skeletons/cpp/c.cpp<CR>")
      vim.keymap.set("n", "<leader>st", "<cmd>:r /home/taarkik/.config/nvim/skeletons/cpp/sparsetable.cpp<CR>")
    end,
  })
end

-- Skeletons
