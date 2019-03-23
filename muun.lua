local _ = [[-----------------------------------------------------------------
-- muun - moonscript compatible class implementation

-- Copyright 2019 megagrump@pm.me
-- License: MIT. See LICENSE for details
-----------------------------------------------------------------]]
local setup
setup = function(__name, __parent, __base)
  local mt = {
    __call = function(self, ...)
      local obj = setmetatable({ }, __base)
      self.__init(obj, ...)
      return obj
    end,
    __newindex = function(self, key, value)
      __base[key] = value
    end
  }
  __base.new = __base.new or function(self) end
  return setmetatable({
    __name = __name,
    __base = __base,
    __parent = __parent,
    __init = function(...)
      return __base.new(...)
    end
  }, mt), mt
end
local extend
extend = function(name, parent, base)
  setmetatable(base, parent.__base)
  local cls, mt = setup(name, parent, base)
  base.__class, base.__index = cls, base
  mt.__index = function(self, key)
    local val = rawget(base, key)
    if val ~= nil then
      return val
    else
      return parent[key]
    end
  end
  if parent.__inherited then
    parent.__inherited(parent, cls)
  end
  return cls
end
local muun = {
  super = function(self, ...)
    return self.__class.__parent.__init(self, ...)
  end
}
return setmetatable(muun, {
  __call = function(self, name, parentOrBase, base)
    if type(name) ~= 'string' then
      error("Invalid class name")
    end
    local parent
    if type(parentOrBase) == 'table' and parentOrBase.__class then
      parent = parentOrBase
    end
    base = not parent and parentOrBase or base or { }
    if parent then
      return extend(name, parent, base)
    end
    local cls, mt = setup(name, nil, base)
    mt.__index, base.__class, base.__index = base, cls, base
    return cls
  end
})
