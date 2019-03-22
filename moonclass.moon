[[-----------------------------------------------------------------
-- moonclass - moonscript compatible class implementation

-- Copyright 2019 megagrump@pm.me
-- License: MIT. See LICENSE for details
-----------------------------------------------------------------]]

setup = (__name, __base, __parent) ->
	mt =
		__call: (...) =>
			obj = setmetatable({}, __base)
			@.__init(obj, ...)
			obj
		__newindex: (key, value) => __base[key] = value

	__base.new or= ->

	setmetatable({
		:__name, :__base, :__parent, __init: (...) -> __base.new(...)
	}, mt), mt

extend = (name, parent, base) ->
	setmetatable(base, parent.__base)

	cls, mt = setup(name, base, parent)

	mt.__index = (key) =>
		val = rawget(base, key)
		val if val ~= nil else parent[key]

	base.__class, base.__index = cls, base
	parent.__inherited(parent, cls) if parent.__inherited
	cls

moonclass =
	super: (...) => @.__class.__parent.__init(@, ...)

setmetatable(moonclass, {
	__call: (name, parentOrBase, base) =>
		error("Invalid class name") if type(name) ~= 'string'
		parent = parentOrBase if type(parentOrBase) == 'table' and parentOrBase.__class
		base = not parent and parentOrBase or base or {}
		return extend(name, parent, base) if parent

		cls, mt = setup(name, base)
		mt.__index, base.__class, base.__index = base, cls, base
		cls
})
