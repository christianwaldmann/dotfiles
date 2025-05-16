return {
    s("date", f(function() return os.date("%d.%m.%Y") end)),
    s("time", f(function() return os.date("%H:%M:%S") end)),
    s("startup", f(function() return io.popen("uptime -s"):read("*a"):gsub("%s+$", "") end)),
}, {}

