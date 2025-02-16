local text = require "text"
local button = text:extend()

button.event_fn = function () end

-- lynx.button(text, event_fn, params)
--  text: string
--  event_fn: function
--  params: table
--
function button:new(_text, event_fn, params)
  text.new(self, _text, params)

  if event_fn then
    self.event_fn = event_fn
  end
end

function button:input(menu, key, state)
  if menu.funcs.simple_key(key) == "enter" and state == "pressed" then
    self:event_fn(menu)
  end
end

function button:mouse(menu, x, y, btn)
  if btn == 1 then
    self:event_fn(menu)
  end
end

return button
