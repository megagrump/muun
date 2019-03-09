# moonclass

A minimal class implementation written in Lua that is compatible with and can extend compiled [moonscript](https://github.com/leafo/moonscript) classes.

## How to use

### Extend a moonscript class
```
local class = require('moonclass')
local MoonScriptClass = require('MoonScriptClass') -- the class we want to extend

local ExtendedClass = {}

 -- override constructor
function ExtendedClass:initialize(x, y)
	-- call parent constructor
	ExtendedClass.__parent.initialize(self)

	self.x, self.y = x, y
	print("Hi! My position is:", x, y)
end

-- derive from MoonScriptClass
ExtendedClass = class.extend('ExtendedClass', ExtendedClass, MoonScriptClass)

-- create an instance
local instance = ExtendedClass(23, 42)
```

### Define a class

moonclass can also be used as a minimal, but fully functional class implementation for Lua.

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

# License

Copyright 2019 megagrump@pm.me

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
