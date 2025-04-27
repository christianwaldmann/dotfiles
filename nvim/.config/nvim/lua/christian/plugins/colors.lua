return {
    "vague2k/vague.nvim",
    lazy=false,
    config = function()
        require("vague").setup({ transparent = true })
        vim.cmd("colorscheme vague")
        vim.cmd(":hi statusline guibg=NONE")
    end
}
