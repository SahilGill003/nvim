return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = {
    { "<leader>T",  "<cmd>Telescope<CR>",            desc = "Telescope" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>ft", "<cmd>Telescope live_grep<CR>",  desc = "Find a string" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>",    desc = "Find keymaps" },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules", ".idea" },
    },
    extensions = {
      fzf = {
        fuzzy = true,               -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case",   -- or "ignore_case" or "respect_case"
      },
    },
  },
  config = function()
    require("telescope").load_extension("fzf")
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ps", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
  end,
}
