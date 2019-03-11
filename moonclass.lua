local _ = [[-----------------------------------------------------------------
-- moonclass - moonscript compatible class implementation

-- Copyright 2019 megagrump@pm.me
-- License: MIT. See LICENSE for details
-----------------------------------------------------------------]]
local setupClass
setupClass = function(__name, __base, __parent)
  local mt = {
    __call = function(cls, ...)
      local self = setmetatable({ }, __base)
      cls.__init(self, ...)
      return self
    end
  }
  return setmetatable({
    __name = __name,
    __base = __base,
    __parent = __parent,
    __init = function(...)
      return __base.new(...)
    end
  }, mt), mt
end
local moonclass = {
  extend = function(name, parent, base)
    setmetatable(base, parent.__base)
    local clazz, mt = setupClass(name, base, parent)
    mt.__index = function(cls, name)
      local val = rawget(base, name)
      if val ~= nil then
        return val
      else
        return parent[name]
      end
    end
    base.__class, base.__index = clazz, base
    if parent.__inherited then
      parent.__inherited(parent, clazz)
    end
    return clazz
  end,
  ["super"] = function(self, ...)
    return self.__class.__parent.__init(self, ...)
  end
}
return setmetatable(moonclass, {
  __call = function(self, name, base)
    local clazz, mt = setupClass(name, base)
    mt.__index, base.__class, base.__index = base, clazz, base
    return clazz
  end
})
