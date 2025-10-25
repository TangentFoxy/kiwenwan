Gamestate = require "lib.gamestate"
terrain = {}
w, h = 960, 540

class Map
  get: (x, y) =>
    return @[x][y] if @[x]
  set: (x, y, value) =>
    @[x] = @[x] or {}
    @[x][y] = value

terrain.init = =>

terrain.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

terrain.update = (dt) =>

terrain.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

  tile_size = 8
  for x = 1, w / tile_size
    for y = 1, h / tile_size
      love.graphics.points x * tile_size - tile_size / 2, y * tile_size - tile_size / 2

terrain.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return terrain
