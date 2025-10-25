Gamestate = require "lib.gamestate"
terrain = {}
w, h = 960, 540

terrain.init = =>

terrain.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

terrain.update = (dt) =>

terrain.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

terrain.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return terrain
