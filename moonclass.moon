[[-----------------------------------------------------------------
-- moonclass - moonscript compatible class implementation

-- Copyright 2019 megagrump@pm.me
-- License: MIT. See LICENSE for details
-----------------------------------------------------------------]]

setupClass = (__name, __base, __parent) ->
	mt =
		__call: (cls, ...) ->
			self = setmetatable({}, __base)
			cls.__init(self, ...)
			self

	setmetatable({
		:__name, :__base, :__parent
		__init: (...) -> __base.new(...)
	}, mt), mt

moonclass =
	extend: (name, parent, base) ->
		setmetatable(base, parent.__base)

		clazz, mt = setupClass(name, base, parent)
		mt.__index = (cls, name) ->
			val = rawget(base, name)
			val if val ~= nil else parent[name]

		base.__class, base.__index = clazz, base
		parent.__inherited(parent, clazz) if parent.__inherited

		clazz

	"super": (self, ...) -> self.__class.__parent.__init(self, ...)

setmetatable(moonclass, {
	__call: (self, name, base) ->
		clazz, mt = setupClass(name, base)
		mt.__index, base.__class, base.__index = base, clazz, base
		clazz
})
