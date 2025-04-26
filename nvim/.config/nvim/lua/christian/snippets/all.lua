return {
    s("date", t(os.date("%d.%m.%Y"))),
    s("time", t(os.date("%H:%M:%S"))),
    s("startup", f(function()
        return io.popen("uptime -s"):read("*a"):gsub("%s+$", "")
    end)),
}, {}
