Gamestate = require "lib.gamestate"
editor = {}
w, h = 960, 540

class Map
  new: (@tile_size) =>

  get: (x, y) =>
    return @[x][y] if @[x]
  set: (x, y, v) =>
    @[x] = @[x] or {}
    @[x][y] = v

class Sprite
  new: (options) =>
    if "table" == type(options)
      if options.source
        @source = options.source
    elseif options
      @source = options

    if @source
      @image = love.graphics.newImage @source
      @width = @image\getWidth! * ((options and options.width) or 1)
      @height = @image\getHeight! * ((options and options.height) or 1)
    else
      @width = options and options.width
      @height = options and options.height

    -- todo options.rotation needs to be converted to radians
    @rotation = (options and options.rotation) or 0
    @color = (options and options.color) or { 1, 1, 1, 1 }

local map, sprites
editor.init = =>
  love.math.setRandomSeed os.time!

  map = Map(40)
  for i = 1, 10
    x, y = math.floor(love.math.random! * 10), math.floor(love.math.random! * 10)
    map\set x, y, 1

  sprites = {}
  assets = { "assets/earth.png", "assets/moon.png" }
  for i = 1, #assets
    source = assets[i]
    table.insert(sprites, Sprite(source))

editor.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

camera = { x: 0, y: 0, w: w, h: h }
editor.update = (dt) =>
  if love.keyboard.isDown "up"
    camera.y -= 200 * dt
  if love.keyboard.isDown "down"
    camera.y += 200 * dt
  if love.keyboard.isDown "left"
    camera.x -= 200 * dt
  if love.keyboard.isDown "right"
    camera.x += 200 * dt

editor.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

  love.graphics.translate w / 2 - camera.x, h / 2 - camera.y

  for x = math.floor((camera.x - w / 2) / map.tile_size) + 1, math.floor((camera.x + w / 2) / map.tile_size) - 1
    for y = math.floor((camera.y - h / 2) / map.tile_size) + 1, math.floor((camera.y + h / 2) / map.tile_size) - 1
      v = map\get x, y
      if v
        if sprites[v]
          sprite = sprites[v]
          love.graphics.setColor sprite.color
          if sprite.image
            love.graphics.draw sprite.image, x * map.tile_size, y * map.tile_size, sprite.rotation, map.tile_size / sprite.width, map.tile_size / sprite.height
        else
          love.graphics.print v, x * map.tile_size, y * map.tile_size

  for x = math.floor((camera.x - w / 2) / map.tile_size) + 2, math.floor((camera.x + w / 2) / map.tile_size) - 1
    love.graphics.line(x * map.tile_size, camera.y - camera.h / 2, x * map.tile_size, camera.y + camera.h / 2)
  for y = math.floor((camera.y - h / 2) / map.tile_size) + 2, math.floor((camera.y + h / 2) / map.tile_size) - 1
    love.graphics.line(camera.x - camera.w / 2, y * map.tile_size, camera.x + camera.w / 2, y * map.tile_size)

  -- temporary mouse -> tile
  x, y = love.mouse.getPosition!
  x, y = math.floor((camera.x + x - camera.w / 2) / map.tile_size), math.floor((camera.y + y - camera.h / 2) / map.tile_size)
  sprite = sprites[2]
  love.graphics.draw sprite.image, x * map.tile_size, y * map.tile_size, 0, map.tile_size / sprite.width, map.tile_size / sprite.height

editor.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return editor
