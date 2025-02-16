local text = require "item":extend()

text.align = "center"
text.text_color = { 1, 1, 1, 1 }
text.selectable = true
text.fade = true

function text.color_fn(self, menu, dt)
  local internal = menu.internal

  if not internal.fade_time then
    internal.fade_time = 0
  end

  internal.fade_time = (internal.fade_time + dt) % (math.pi * 2)

  self.color[1] = math.max(0.25, (math.abs(math.cos(menu.internal.fade_time))))
  self.color[2] = .75
  self.color[3] = math.max(0.25, (math.abs(math.sin(menu.internal.fade_time))))
  self.color[4] = 1
end

function text:new(text, params)
  if params then
    for k,v in pairs(params) do
      self[k] = v
    end
  end

  self.text = text
  self.selected_color = { 0, 0, 0, 0 }
  self.color = self.text_color
end

function text:update(menu, dt)
  if menu:current_item() == self then
    self.color = self.selected_color

    if self.fade then
      self:color_fn(menu, dt)
    end
  else
    self.color = self.text_color
  end
end

function text:draw(menu, x, y, w, h)
  if self.text then
    menu.funcs.draw_text(menu, self.text, self.color, x, y, w, self.align)
  end
end

function text:__tostring()
  return "lynx.text"
end

return text
