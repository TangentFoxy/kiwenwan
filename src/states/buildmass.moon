Gamestate = require "lib.gamestate"
buildmass = {}
w, h = 960, 540

class Body
  new: =>
    -- TODO replace with a circular distribution
    @mass = love.math.random!
    @radius = 0.5 -- TODO radius should be based on mass
    @x = love.math.random! * 500 - 250
    @y = love.math.random! * 500 - 250
    @vx = love.math.random! - 0.5
    @vy = love.math.random! - 0.5
    -- @vx = 0
    -- @vy = 0

lowest, highest = 1e10, 0 -- range of forces witnessed
-- TODO if a force of less than 1e-10 is detected, the farthest object from zero will be removed to reduce computation time
gravity = (A, B) ->
  x = A.x - B.x
  y = A.y - B.y
  distance_squared = x^2 + y^2

  return if distance_squared <= 0 or distance_squared ~= distance_squared
  force = 10 / distance_squared -- instead of including masses here, each body has its force multiplied by the other bodies' mass (two fewer calculations per call)

  direction = math.atan2(y, x)
  cos = math.cos direction
  sin = math.sin direction

  A.vx -= force * B.mass * cos
  A.vy -= force * B.mass * sin
  B.vx += force * A.mass * cos
  B.vy += force * A.mass * sin

  lowest = force if force < lowest
  highest = force if force > highest

buildmass.init = =>
  love.math.setRandomSeed os.time!

  buildmass.bodies = {}
  for i = 1, 100
    table.insert buildmass.bodies, Body!

buildmass.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

iterations = 0
buildmass.update = (dt) =>
  iterations += 1
  -- I'm not caring about dt for this simulation because I want it running as fast as possible instead of consistently
  -- this cannot handle collisions :\
  for i = 1, #buildmass.bodies - 1
    for j = i + 1, #buildmass.bodies
      gravity(buildmass.bodies[i], buildmass.bodies[j])
  for body in *buildmass.bodies
    body.x += body.vx
    body.y += body.vy

buildmass.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)
  love.graphics.print "Highest: #{highest} Lowest: #{lowest} (Iteration: #{iterations})", 1, h - 2 * (fontSize + 1)

  for body in *buildmass.bodies
    love.graphics.points body.x, body.y

buildmass.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return buildmass
