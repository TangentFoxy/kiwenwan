Gamestate = require "lib.gamestate"
TEMPLATE = {}
w, h = 960, 540

TEMPLATE.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

TEMPLATE.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

TEMPLATE.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return TEMPLATE
