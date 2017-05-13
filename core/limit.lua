
local M = {version = "0.0.1"}

local mt = {__index = M}

function M:new()
    return setmetatable({}, mt)
end

function M:get_cache_key(api)
    local cache_key = "limit:"
    return cache_key .. api
end

function M:incr(api)
    local config = require "core.config"
    local redis = require "resty.redis"
    local red = redis:new()
    red:set_timeout(config.redis_timeout)
    local ok, err = red:connect(config.redis_host, config.redis_port)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err)
        return
    end
    local cache_key = self:get_cache_key(api)
    local count, err = red:incr(cache_key)
    ngx.say(count)
end

function M:get(api)
    local config = require "core.config"
    local redis = require "resty.redis"
    local red = redis:new()
    red:set_timeout(config.redis_timeout)
    local ok, err = red:connect(config.redis_host, config.redis_port)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err)
        return
    end
    local cache_key = self:get_cache_key(api)
    local count, err = red:gett(cache_key)
    ngx.say(count)
end

return M

