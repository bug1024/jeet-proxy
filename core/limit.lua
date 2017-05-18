
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
    local count, err = red:get(cache_key)

    if count ~= ngx.null and tonumber(count) > 5 then
        ngx.say("too many requests: ", count)
        return
    end

    red:init_pipeline()

    local ret, err = red:incr(cache_key)
    -- todo
    if count ~= ngx.null and tonumber(count) == 0 then
        ngx.say("first request")
        red:expire(cache_key, 10)
    end

    local ret, err = red:commit_pipeline()
    if not ret then
        ngx.say("failed to commit the pipelined requests: ", err)
    end

    ngx.say("requests: ", count)
    return true
end

return M

