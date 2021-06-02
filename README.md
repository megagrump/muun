# muun

A minimal Lua class implementation that is compatible with [moonscript](https://github.com/leafo/moonscript) classes.  

muun can extend classes defined in moonscript from Lua code, and define classes in Lua code that can be extended from moonscript code.

## How to use
### Extending moonscript classes from Lua code
```lua
local class = require('muun')
local MoonScriptClass = require('MoonScriptClass') -- the class we want to extend

local ExtendedClass = class('ExtendedClass', MoonScriptClass)

 -- override constructor
function ExtendedClass:new(x, y)	
	ExtendedClass.__super(self) -- calls MoonScriptClass constructor

	self.x, self.y = x, y
	print("Hi! My position is:", x, y)
end

-- create an instance
local instance = ExtendedClass(23, 42)
```
---
### Extending classes written in Lua from moonscript code
```lua
local class = require('muun')

BaseClass = class('BaseClass')

function BaseClass:new()
	print("Hi from Lua")
end

function BaseClass:__inherited(cls)
	print(self.__name, "inherited from", cls.__name)
end

```
```moonscript
BaseClass = require('BaseClass')

class Derived extends BaseClass
	new: =>
		super! -- calls the BaseClass constructor
		print("Hi from moonscript!")

test = Derived!
```
#### Output
```
Derived	inherited from 	BaseClass
Hi from Lua!
Hi from moonscript!
```
---
### Define a class in Lua

muun can also be used as a minimal, but fully functional Lua class implementation.

#### Variant 1
```lua
-- define class
local MyClass = class('MyClass', {
	 -- define constructor
	new = function(self, x, y)
		self.x, self.y = x, y
		print("Hi! My position is:", x, y)
	end,
})

-- create instance
local instance = MyClass(23, 42)
```

#### Variant 2
```lua
local MyClass = class('MyClass')

 -- define constructor
function MyClass:new(x, y)
	self.x, self.y = x, y
	print("Hi! My position is:", x, y)
end

-- create instance
local instance = MyClass(23, 42)
```

#### Variant 3
```lua
local MyClass = {
	 -- define constructor
	new = function(self, x, y)
		self.x, self.y = x, y
		print("Hi! My position is:", x, y)
	end,
}

-- define class
MyClass = class('MyClass', MyClass)

-- create instance
local instance = MyClass(23, 42)
```
---
### Inheritance
All derived classes have a `__super` table that acts as a proxy for the base class. **Note**: `__super` is not an alias for the base class as in MoonScript, it's merely a proxy that allows you to access the base class.

If a class implements the `__inherited` method, it gets called whenever another class extends this class.
```lua
local Base = class('Base')

function Base:new(...)
    print("Hi from Base!")
end

function Base:foo()
    print("Foo!")
end

function Base.__inherited(parent, cls)
    print(cls.__name .. " inherited from " .. parent.__name)
end

local Derived = class('Derived', Base)

function Derived:new(...)
    Derived.__super(self, ...)
    print("Hi from Derived!")
end

function Derived:foo()
    Derived.__super.foo(self)
    print("Bar!")
end

local instance = Derived()
instance:foo()
```

### Output:
```
Derived inherited from Base
Hi from Base!
Hi from Derived!
Foo!
Bar!
```
---
# License

Copyright 2019, 2021 megagrump@pm.me

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
