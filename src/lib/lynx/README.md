# Lynx

Lynx is a very-lightweight work-in-progress list-based UI library. It allows to
build efficient and functionnal menues with only a few lines of codes and without
needing to worry about the coordinates of all menu elements.

It also includes a minimal C port.

# Installation
To use Lynx, place this directory in your project, then when you need Lynx :
```lua
local lynx = require "lynx"
-- or
local lynx = require "path.to.lynx"
```

You also need a "funcs" table which contains all platform-specific functions to draw our menu.
For love2d, you can use love-lynx :
```lua
local lynx_funcs = lynx.love_lynx
```

# Creation

To create a menu, you need a item list (which is a table containing items you can make with e.g lynx.button)
and a parameter table which contains few parameters as defined in menu.lua.

A demo menu :
```lua
menu = lynx.menu({
  lynx.text "Sample text 1",
  lynx.text "Sample text 2",
  lynx.text "Sample text 3",
  lynx.button("Simple hello button", function () print "Hello World !" end, {})
}, {
  viewport = { 0, 0, 300, 200 },
  offset = { 0, 50 },
  default_height = 20,
  funcs = lynx_funcs
})
```

# Usage

### Modifying a menu

You can access all parameters of few other things directly from menu.
All informations of params are copied into this table, you can safely
modify these parameters.
menu.current must be lower than #menu.items otherwise, behavior is undefined.

### Updating a menu

```lua
menu:update(dt)
```
Update all items with item:update(dt).

### Drawing a menu

```lua
menu:draw()
```
Draw all items with correct coordinates at menu.viewport.

### Managing input

```lua
menu:input_key(key, key_state)
```
Insert key event, can be a platform-specific key if funcs.simpleKey is implemented to consider them.
key_state might be "pressed", "up" or "down".

```lua
menu:input_mouse(x, y, btn)
```
Insert mouse event, x, y, btn must be numbers, btn can be 0 which indicate no button pressed.
Some specific buttons have some defined behavior :
 - btn == 0 : Inserts `menu:input_key("enter", "pressed")` event.
 - btn == 1 : Do `menu:pop()`

These behavior currently cannot be customized.

### And then ?

As this project is still work-in-progress, bugs can exist, some features can be missing, some
others are hard-coded.
This library is designed to be very simple and lightweight with a modular architecture (following
the KISS philosophy) while still being functionnal and powerful.
