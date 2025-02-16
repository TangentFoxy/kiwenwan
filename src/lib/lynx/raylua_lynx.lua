return {
  simple_key = function (k)
    return k
  end,
  draw_background = function (menu, x, y, w, h)
    local r, g, b, a = unpack(menu.background)
    r, g, b, a = r * 255, g * 255, b * 255, a * 255

    rl.DrawRectangle(x, y, w, h, rl.new("Color", r, g, b, a))
  end,
  draw_text = function (menu, text, color, x, y, w, align)
    local r, g, b, a = unpack(color)
    r, g, b, a = r * 255, g * 255, b * 255, a * 255

    rl.DrawText(text, x, y, 20, rl.new("Color", r, g, b, a))
  end
}
