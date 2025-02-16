local text = require "text"
local list = text:extend()

list.value_index = 1
list.editable = true
list.selectable = true
list.loop = true
list.format = "%s"

list.event_fn = function () end

-- lynx.observer(variable, key, format, params)
--  values: table
--  event_fn: function (self, value)
--  params: table
--
function list:new(values, event_fn, params)
  text.new(self, nil, params)

  if event_fn then
    self.event_fn = event_fn
  end

  self.values = values or {}
  self.value = self.values[self.value_index]

  self.selected = false

  self.text = self:format_fn(false)
end

function list:format_fn(locked)
  local str = string.format(self.format, self.value)

  if locked then
    if self.value_index > 1 or self.loop then
      str = "< " .. str
    end

    if self.value_index < #self.values or self.loop then
      str = str .. " >"
    end
  end

  return str
end

function list:input(menu, key, state)
  if (not self.allow_repeat and state == "down") or state == "up" then
    return
  end

  if self.editable then
    if menu.funcs.simple_key(key) == "enter" and state == "pressed" then
      self.selected = not self.selected
      menu.locked = self.selected
      self.text = self:format_fn(self.selected)

    elseif self.selected then
      if menu.funcs.simple_key(key) == "left" then
        self.value_index = self.value_index - 1

        if self.value_index == 0 then
          self.value_index = self.loop and #self.values or 1
        end

        self.value = self.values[self.value_index]

        self:event_fn(menu, self.value)
        self.text = self:format_fn(self.selected)

      elseif menu.funcs.simple_key(key) == "right" then
        self.value_index = self.value_index + 1

        if self.value_index == #self.values + 1 then
          self.value_index = self.loop and 1 or #self.values
        end

        self.value = self.values[self.value_index]

        self:event_fn(menu, self.value)
        self.text = self:format_fn(self.selected)
      end
    end
  end
end

function list:mouse(menu, x, y, btn)
  if btn == 1 then
    self:input(menu, "enter", "pressed")
  end
end

function list:__tostring()
  return "lynx.list"
end

return list
