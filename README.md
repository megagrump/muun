# moonclass

Create and extend moonscript classes from Lua code.

moonclass is a minimal Lua class implementation that is compatible with [moonscript](https://github.com/leafo/moonscript) classes.

## How to use

### Define a class
#### Variant 1
```
local class = require('moonclass')

local MyClass = {}

 -- define constructor
function MyClass:initialize(x, y)
	self.x, self.y = x, y
	print("Hi! My position is:", x, y)
end

-- define class
MyClass = class('MyClass', MyClass)

-- create instance
local instance = MyClass(23, 42)
```

#### Variant 2
```
local class = require('moonclass')

local MyClass = {
	 -- define constructor
	initialize = function(self, x, y)
		self.x, self.y = x, y
		print("Hi! My position is:", x, y)
	end,
}

-- define class
MyClass = class('MyClass', MyClass)

-- create instance
local instance = MyClass(23, 42)
```

### Extend a moonscript class (or a moonclass)
```
local class = require('moonclass')
local MoonScriptClass = require('MoonScriptClass')

local ExtendedClass = {}

 -- override constructor
function ExtendedClass:initialize(x, y)
	ExtendedClass.__parent.initialize(self)
	self.x, self.y = x, y
	print("Hi! My position is:", x, y)
end

-- define class
ExtendedClass = class.extend('ExtendedClass', ExtendedClass, MoonScriptClass)

-- create instance
local instance = ExtendedClass(23, 42)
```

