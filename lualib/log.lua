local skynet = require "skynet"

local log = {}

local LOG_LEVEL = {
    DEBUG   = 1,
    INFO    = 2, 
    WARN    = 3, 
    ERROR   = 4, 
    FATAL   = 5
}

local OUT_PUT_LEVEL = LOG_LEVEL.DEBUG

local LOG_LEVEL_DESC = {
    [1] = "DEBUG",
    [2] = "INFO",
    [3] = "WARN",
    [4] = "ERROR",
    [5] = "FATAL",
}

local function format(fmt, ...)
    local ok, str = pcall(string.format, fmt, ...)
    if ok then
        return str
    else
        return "error format : " .. fmt
    end
end

local function send_log(level, ...)
    if level < OUT_PUT_LEVEL then
        return
    end

    local str
    if select("#", ...) == 1 then
        str = tostring(...)
    else
        str = format(...)
    end

    local info = debug.getinfo(3)
	if info then
		local filename = string.match(info.short_src, "[^/.]+.lua$")
		str = string.format("[%s:%d] %s", filename, info.currentline, str)
    end
    
    skynet.send(".logger", "lua", "logging", LOG_LEVEL_DESC[level], str)
end

function log.debug(fmt, ...)
    send_log(LOG_LEVEL.DEBUG, fmt, ...)
end

function log.info(fmt, ...)
    send_log(LOG_LEVEL.INFO, fmt, ...)
end

function log.warn(fmt, ...)
    send_log(LOG_LEVEL.WARN, fmt, ...)
end

function log.error(fmt, ...)
    send_log(LOG_LEVEL.ERROR, fmt, ...)
end

function log.fatal(fmt, ...)
    send_log(LOG_LEVEL.FATAL, fmt, ...)
end

return log
