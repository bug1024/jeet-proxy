
local limit = require 'core.limit'

local l = limit:new()

local api = "/user/1"
l:incr(api)
l:get(api)
