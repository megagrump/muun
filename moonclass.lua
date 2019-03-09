--[[
moonclass - moonscript compatible class implementation for Lua
Copyright (c) 2019 megagrump@pm.me
License: MIT
See LICENSE for details
]]
local moonclass = {}

local function setupClass(name, base, parent)
	return {
		__name = name,
		__base = base,
		__parent = parent,
		__init = function(...)
			return base.initialize(...)
		end,
	}
end

local function defineClass(name, base)
	base.__index = base

	local class = setmetatable(setupClass(name, base), {
		__index = base,
		__call = function(cls, ...)
			local self = setmetatable({}, base)
			cls.__init(self, ...)
			return self
		end,
	})

	base.__class = class
	return class
end

function moonclass.extend(name, parent, base)
	base.__index = base
	setmetatable(base, parent.__base)

	local class = setmetatable(setupClass(name, base, parent), {
		__index = function(cls, name)
			local val = rawget(base, name)
			if val == nil then return parent[name] end
			return val
		end,
		__call = function(cls, ...)
			local self = setmetatable({}, base)
			cls.__init(self, ...)
			return self
		end,
	})

	base.__class = class
	if parent.__inherited then
		parent.__inherited(parent, class)
	end
	return class

end

return setmetatable(moonclass, {
	__call = function(self, name, base)
		return defineClass(name, base)
	end
})
