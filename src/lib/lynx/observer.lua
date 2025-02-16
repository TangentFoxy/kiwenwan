local text = require "text"
local observer = text:extend()

observer.raw = false
observer.format = "%s: %s"
observer.continous = true

-- lynx.observer(variable, key, format, params)
--  variable: table
--  key: any
--  format: string (by default, format_fn uses string.format with key and value)
--  params: table
--
function observer:new(variable, key, format, params)
  text.new(self, nil, params)

  self.variable = variable or {}
  self.key = key
  self.format = format
  self.value = variable[key]

  self.text = self:format_fn()
end

function observer:format_fn()
  return string.format(self.format, self.key, self.value)
end

function observer:update(menu, dt)
  self.super.update(self, menu, dt)

  if not self.selected or self.continous then -- allow merging with editors
    local var = self.variable
    local value = self.raw and rawget(var, self.key) or var[self.key]

    if self.value ~= value then
      self.value = value
      self.text = self:format_fn(self.selected)
    end
  end
end

function observer:__tostring()
  return "lynx.observer"
end

return observer
