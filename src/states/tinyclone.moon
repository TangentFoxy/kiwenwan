Gamestate = require "lib.gamestate"
tinyclone = {}
w, h = 960, 540

tinyclone.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

tinyclone.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return tinyclone
