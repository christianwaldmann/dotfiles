-- gcc to toggle a comment, or visual select first and gc afterwards
return {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
        require("Comment").setup()
    end
}

