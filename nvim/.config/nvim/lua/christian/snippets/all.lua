return {
    s("date", t(os.date("%d.%m.%Y"))),
    s("time", t(os.date("%H:%M:%S"))),
    s("startup", f(function()
        local handle = io.popen("uptime -s")
        local result = handle:read("*a")
        handle:close()
        return (result:gsub("%s+$", ""))
    end)),
}, {}