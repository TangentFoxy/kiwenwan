Gamestate = require "lib.gamestate"
colortest = {}
w, h = 960, 540

-- all of this should be in an init?
-- increasing brightness by up to 15% or decreasing by up to 4% across all channels is effective
base_colors = {
  O: {0.521, 0.521, 0.996, 1}
  B: {0.701, 0.898, 1, 1}
  A: {0.98, 0.98, 0.98, 1}
  F: {1, 0.996, 0.780, 1}
  G: {0.988, 0.972, 0.250, 1}
  K: {0.905, 0.549, 0.015, 1}
  M: {0.847, 0.011, 0.031, 1}
  L: {0.302, 0.187, 0.177, 1}
}

highlights = {}
for name, group in pairs base_colors
  new_group = {}
  highlights[name] = new_group
  for index, channel in ipairs group
    new_group[index] = math.min channel + channel * 0.15, 1

darker = {}
for name, group in pairs base_colors
  new_group = {}
  darker[name] = new_group
  for index, channel in ipairs group
    if index == 4
      new_group[4] = 1
    else
      new_group[index] = math.max channel - channel * 0.04, 0

mixtures = {"OB", "BA", "AF", "FG", "GK", "KM", "ML", "LO"}
halfmix = {}
for pair in *mixtures
  new_group = {}
  a, b = pair\sub(1,1), pair\sub(2,2)
  halfmix[a] = new_group
  for i = 1, 4
    -- 50/50
    new_group[i] = (base_colors[a][i] + base_colors[b][i] ) / 2
    -- 90/10
    -- new_group[i] = base_colors[a][i] * 0.9 + base_colors[b][i] * 0.1
    -- 10/90
    -- new_group[i] = base_colors[a][i] * 0.1 + base_colors[b][i] * 0.9

colortest.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

colortest.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

  draw_stars = (color_table, height) ->
    radius = h / 2
    x = 0
    order = {"O", "B", "A", "F", "G", "K", "M", "L"}
    for star_type in *order
      love.graphics.setColor color_table[star_type]
      love.graphics.circle "fill", x, height, radius
      x += radius
      radius /= 1.75
      height /= 1.5

  draw_stars base_colors, h / 2
  draw_stars highlights, 0
  draw_stars darker, h
  draw_stars halfmix, h / 2

colortest.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return colortest
