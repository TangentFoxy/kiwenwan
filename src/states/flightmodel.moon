Gamestate = require "lib.gamestate"
flightmodel = {}
w, h = 960, 540

distance = (x1, y1, x2, y2) ->
  xDelta = x1 - x2
  yDelta = y1 - y2
  return math.sqrt xDelta^2 + yDelta^2

distance2 = (x1, y1, x2, y2) ->
  xDelta = x1 - x2
  yDelta = y1 - y2
  return xDelta^2 + yDelta^2

orbitalSpeed = 0.0625 * 2500
class Body
  new: (@orbitalRadius, @bodyRadius) =>
    @rotationOffset = math.pi * 2 * love.math.random!
    @color = { love.math.random!, love.math.random!, love.math.random!, 1 }
    
  draw: (time) =>
    x, y = @getPosition(time)
    love.graphics.setColor @color
    love.graphics.circle "fill", x, y, @bodyRadius
    love.graphics.setColor { 1, 1, 1, 1 } -- temporary, want everything to just set its color

  getPosition: (time) =>
    argument = time * orbitalSpeed / @orbitalRadius^1.337 + @rotationOffset
    argument = 0 if (argument > math.huge) or (argument != argument)
    return @orbitalRadius * math.cos(argument), @orbitalRadius * math.sin(argument)

class Ship
  new: =>
    @orbitalRadius = 0
    @rotationOffset = 0
    @x, @y = 30, 30
    @orbiting = false
    @timeOffset = 0
    @parent = nil

  draw: (time) =>
    x, y = @getPosition(time)
    love.graphics.rectangle "line", x - 3, y - 3, 6, 6

  getPosition: (time) =>
    if @orbiting
      local x, y
      if @parent
        x, y = @parent\getPosition time
      else
        x, y = 0, 0
      argument = (time - @timeOffset) * orbitalSpeed / @orbitalRadius^1.337 + @rotationOffset
      argument = 0 if (argument > math.huge) or (argument != argument)
      return x + @orbitalRadius * math.cos(argument), y + @orbitalRadius * math.sin(argument)
    else
      return @x, @y

flightmodel.init = =>
  love.math.setRandomSeed os.time!
  flightmodel.time = os.time!
  flightmodel.speed = 1

  -- todo generate bodies
  flightmodel.bodies = {}
  table.insert(flightmodel.bodies, Body(0, 25))
  for i=1, 10
    table.insert flightmodel.bodies, Body(love.math.random! * 200 + 100, love.math.random! * 4 + 1)

  flightmodel.ship = Ship!
  table.insert flightmodel.bodies, flightmodel.ship

flightmodel.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

camera = { x: 0, y: 0 }
flightmodel.update = (dt) =>
  flightmodel.time += dt * flightmodel.speed

  if love.keyboard.isDown "up"
    camera.y -= 200 * dt
  if love.keyboard.isDown "down"
    camera.y += 200 * dt
  if love.keyboard.isDown "left"
    camera.x -= 200 * dt
  if love.keyboard.isDown "right"
    camera.x += 200 * dt

  if not flightmodel.ship.orbiting
    if love.keyboard.isDown "w"
      flightmodel.ship.y -= 100 * dt
    if love.keyboard.isDown "s"
      flightmodel.ship.y += 100 * dt
    if love.keyboard.isDown "a"
      flightmodel.ship.x -= 100 * dt
    if love.keyboard.isDown "d"
      flightmodel.ship.x += 100 * dt

flightmodel.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu. arrows: Camera movement. wasd: Ship movement. o: Toggle ship orbit.", 1, h - (fontSize + 1)

  love.graphics.translate w / 2 - camera.x, h / 2 - camera.y

  for body in *flightmodel.bodies
    body\draw flightmodel.time

flightmodel.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!
    when "-"
      flightmodel.speed /= 2
    when "="
      flightmodel.speed *= 2
    when "o"
      if flightmodel.ship.orbiting
        x, y = flightmodel.ship\getPosition(flightmodel.time)
        flightmodel.ship.x = x
        flightmodel.ship.y = y
        flightmodel.ship.orbiting = false
      else
        -- only works with "sun"
        flightmodel.ship.orbitalRadius = math.sqrt(flightmodel.ship.x^2 + flightmodel.ship.y^2)
        flightmodel.ship.rotationOffset = math.atan2(flightmodel.ship.y, flightmodel.ship.x)
        flightmodel.ship.timeOffset = flightmodel.time
        flightmodel.ship.orbiting = true

return flightmodel
