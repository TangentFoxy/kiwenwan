Gamestate = require "lib.gamestate"
tinyclone = {}
w, h = 960, 540

tinyclone.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

tinyclone.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

tinyclone.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return tinyclone
