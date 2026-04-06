local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
map("n", "<Esc>", "<cmd>noh<cr><esc>", { desc = "Clear Search Highlight" })
