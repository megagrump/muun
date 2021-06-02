local _ = [[-----------------------------------------------------------------
-- muun - moonscript compatible class implementation

-- Copyright 2019, 2021 megagrump@pm.me
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
    __index = __base,
    __newindex = function(self, key, value)
      __base[key] = value
    end
  }
  __base.new = __base.new or function(self) end
  local cls = setmetatable({
    __init = function(...)
      return __base.new(...)
    end,
    __name = __name,
    __base = __base,
    __parent = __parent
  }, mt)
  do
    __base.__class, __base.__index = cls, __base
  end
  return cls
end
local super
super = function(parent)
  return setmetatable({ }, {
    __call = function(self, this, ...)
      return parent.__init(this, ...)
    end,
    __index = parent
  })
end
local extend
extend = function(name, parent, base)
  setmetatable(base, parent.__base)
  local cls = setup(name, parent, base)
  cls.__super = super(parent)
  if parent.__inherited then
    parent.__inherited(parent, cls)
  end
  return cls
end
return function(name, parentOrBase, base)
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
  else
    return setup(name, nil, base)
  end
end
