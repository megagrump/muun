--[[-----------------------------------------------------------------
moonclass - moonscript compatible class implementation

Copyright 2019 megagrump@pm.me
License: MIT. See LICENSE for details
]]-------------------------------------------------------------------
local moonclass = {}

local function setupClass(name, base, parent)
	local mt = {
		__call = function(cls, ...)
			local self = setmetatable({}, base)
			cls.__init(self, ...)
			return self
		end,
	}

	return setmetatable({
		__name = name,
		__base = base,
		__parent = parent,
		__init = function(...)
			return base.initialize(...)
		end,
	}, mt), mt
end

local function defineClass(name, base)
	local class, mt = setupClass(name, base)
	mt.__index, base.__class, base,__index = base, class, base
	return class
end

function moonclass.extend(name, parent, base)
	setmetatable(base, parent.__base)

	local class, mt = setupClass(name, base, parent)
	mt.__index = function(cls, name)
		local val = rawget(base, name)
		if val == nil then return parent[name] end
		return val
	end

	base.__class, base.__index = class, base
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
