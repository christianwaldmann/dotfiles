return {
     "L3MON4D3/LuaSnip",
     version = "v2.1.0",
     lazy = true,
     event = "InsertEnter",  -- Load when entering insert mode
     config = function()
       vim.defer_fn(function()
         require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/christian/snippets/" })
       end, 100)  -- Delay loading by 100ms to ensure LuaSnip is ready

       local ls = require("luasnip")
       vim.keymap.set({ "i" }, "<C-e>", function() ls.expand() end, { silent = true })
       vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
       vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
       ls.config.setup({
           enable_autosnippets = true,
           region_check_events = 'InsertEnter',
           delete_check_events = 'InsertLeave'
       })

     end,
}
