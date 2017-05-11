
local M = {}
M.version = "0.0.1"

local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.ERR, "failed to connect: ", err)
    return
end

M.get_config = function(api)
    local config = {}
    return config
end

M.get_cache_key = function(api)
    local cache_key = ""
    return cache_key .. api
end

M.incr = function(api)
    local config = self.get_config(api)
    local cache_key = self.get_cache_key(api)
    local count, err = red:incr()
    ngx.say(count)
    -- TODO
end

return M

