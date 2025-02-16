return {
  simple_key = function (k) return k end,
  draw_background = function (menu, x, y, w, h)
    local background = menu.background

    -- Backup previous color.
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(background)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(r, g, b, a)
  end,
  draw_text = function (menu, text, color, x, y, w, align)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(color)
    love.graphics.printf(text, x, y, w, align)
    love.graphics.setColor(r, g, b, a)
  end
}
