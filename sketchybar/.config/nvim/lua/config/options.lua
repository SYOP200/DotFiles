local opt = vim.opt

vim.g.autoformat = true

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.guicursor = table.concat({
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250",
}, ",")
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3
opt.showmode = false
opt.pumblend = 10
opt.winblend = 10
opt.conceallevel = 0
opt.list = true
opt.listchars = {
  tab = "> ",
  trail = "-",
  nbsp = "+",
}
opt.fillchars = {
  eob = " ",
}
opt.updatetime = 200
opt.confirm = true
