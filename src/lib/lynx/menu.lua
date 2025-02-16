--[[
  -- Menu Engine --

  Menu parameters (also available as members) :

    x, y, w, h:
      Viewport of the menu. (numbers)

    ox, oy:
      Offset of the menu. (numbers)

    current:
      Current selected element (integer)

    background:
      Color of the background table. (table[4]:{ r, g, b, a })

    locked:
      Locks the menu entry, thus, up and down are now catched by input instead
      of the menu. menu:pop() is ignored when menu is locked. (boolean)

    internal:
      Reserved for items, useful for shared stuff such as text fading. (table)

    default_height:
      Default item height if height is not defined in item. (number)

    funcs :
      Generic functions to draw stuff, required for basic stuff.
        - draw_background(menu) :
            Draws background (function)
        - draw_text(menu, text, color, x, y, w, align) :
            Prints a text at x, y (function)
        - simple_key(key) :
            Translates a key from "input" to a key readable by lynx
            (either "left", "right", "up", "down" or "enter")
]]

local menu = require "classic":extend()

-- Menu defaults
menu.current = 1
menu.background =  { .25, .25, .25, .25 }
menu.locked = false
menu.default_height = 10
menu.x, menu.y, menu.ox, menu.oy = 0, 0, 0, 0
menu.w, menu.h = 0, 0

function menu:new(items, params)
  if #items == 0 then
    -- We can't have no items.
    items[1] = { selectable = true }
  end

  self.items = items

  if params then
    for k,v in pairs(params) do
      self[k] = params[k]
    end
  end

  self.stack = {}
  self.internal = {}
end

function menu:current_item()
  return self.items[self.current]
end

function menu:push(new_menu)
  local pushed = {}

  for k,v in pairs(new_menu) do
    if k ~= "stack" then
      pushed[k] = self[k]
      self[k] = v
    end
  end

  self.stack[#self.stack + 1] = pushed
end

function menu:pop()
  -- Don't do anything if already in top menu or menu is locked.
  if #self.stack > 0 and not self.locked then
    -- Pop the menu
    local latest_menu = self.stack[#self.stack]
    -- Remove this menu from stack
    self.stack[#self.stack] = nil

    for k,v in pairs(latest_menu) do
      self[k] = v
    end
  end
end

function menu:up()
  if not self.locked then
    local old = self.current

    while self.current > 1 do
      self.current = self.current - 1
      if self:current_item().selectable ~= false then
        return
      end
    end

    self.current = old
  end
end

function menu:down()
  if not self.locked then
    local old = self.current

    while self.current < #self.items do
      self.current = self.current + 1
      if self:current_item().selectable then
        return
      end
    end

    self.current = old
  end
end

function menu:item_viewport(item)
  local found = false
  local y = 0

  -- Find which item it corresponds
  for i,it in ipairs(self.items) do
    if item == it then
      found = true
      break
    end

    y = y + (it.height or self.default_height)
  end

  if not found then
    return
  end

  -- ax, ay, bx, by
  return 0, y, self.w, y + (item.height or self.default_height)
end

function menu:update(dt)
  -- Update each items
  for _,item in ipairs(self.items) do
    if item.update then
      item:update(self, dt)
    end
  end
end

function menu:draw(x, y)
  local current_item = self:current_item()

  -- Draw each item
  local x, y = (x or self.x) + self.ox, (y or self.y) + self.oy
  local w = self.w - self.ox

  for i,item in ipairs(self.items) do
    local h = item.height or self.default_height

    if current_item == item then
      self.funcs.draw_background(self, x, y, w, h)
    end

    if item.draw then
      item:draw(self, x, y, w, h)
    end

    y = y + h
  end
end

function menu:input_key(key, state)
  local current_item = self:current_item()

  if not self.locked and state == "pressed" then
    -- Control menu navigation
    local simple_key = self.funcs.simple_key(key)

    if simple_key == "up" then
      self:up()
      return
    elseif simple_key == "down" then
      self:down()
      return
    end
  end

  if current_item and current_item.input then
    current_item:input(self, key, state)
  end
end

function menu:input_mouse(x, y, btn)
  local current_item = self:current_item()

  local vx, vy = self.x + self.ox, self.y + self.oy
  local vw, vh = self.w - self.ox, self.h - self.oy

  local item_y = 0

  if vx <= x and x <= vx + vw and vy <= y and y <= vy + vh then
    -- Mouse is inside the viewport, YAY

    if not self.locked then
      local vp_y = y - vy

      local y = 0
      -- Find which item it corresponds
      for i,item in ipairs(self.items) do
        y = y + (item.height or self.default_height)

        if vp_y < y then
          if self.items[i].selectable then
            self.current = i
            current_item = self:current_item()
          end
          break
        end

        item_y = item_y + (item.height or self.default_height)
      end
    end

    if current_item and current_item.mouse then
      current_item:mouse(self, x - vx, y - item_y - vy, btn)
    end
  end
end

function menu:input_text(string)
  local current_item = self:current_item()

  if current_item and current_item.text then
    current_item:text(self, string)
  end
end

function menu:__tostring()
  return "lynx.menu"
end

return menu
