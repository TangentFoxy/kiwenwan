local text = require "text"
local slider = text:extend()

slider.min_value = 0
slider.max_value = 10
slider.step = 1
slider.value = 5
slider.format = "%g"
slider.editable = true
slider.event_fn = function() end

-- lynx.slider(event, params)
--  event: function(self, menu, new_value)
--  params: table
--
function slider:new(event, params)
  text.new(self, nil, params)

  if event then
    self.event_fn = event
  end

  self.selected = false
  self.text = self:format_fn(false)
end

function slider:format_fn(locked)
  local str = string.format(self.format, self.value)

  if locked then
    if self.value > self.min_value then
      str = "< " .. str
    end

    if self.value < self.max_value then
      str = str .. " >"
    end
  end

  return str
end

function slider:input(menu, key, state)
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
        self.value = math.max(self.min_value, self.value - self.step)
        self:event_fn(menu, self.value)
        self.text = self:format_fn(self.selected)

      elseif menu.funcs.simple_key(key) == "right" then
        self.value = math.min(self.max_value, self.value + self.step)
        self:event_fn(menu, self.value)
        self.text = self:format_fn(self.selected)
      end
    end
  end
end

function slider:mouse(menu, x, y, btn)
  if btn == 1 then
    self:input(menu, "enter", "pressed")
  end
end

function slider:__tostring()
  return "lynx.slider"
end

return slider
