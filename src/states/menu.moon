Gamestate = require "lib.gamestate"
menu = {}
w, h = 800, 600

menu.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

menu.keypressed = (key) =>
  switch key
    when "escape"
      love.event.quit!
    when "g"
      Gamestate.push require "states.galaxy"
    when "t"
      Gamestate.push require "states.tinyclone"

return menu
