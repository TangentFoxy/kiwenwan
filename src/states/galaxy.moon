Gamestate = require "lib.gamestate"
galaxy = {}
w, h = 960, 540

units = {
  au2ly: 1.58125e-5
  ls2ly: 3.17098e-8
  au2ls: 499.005
  au2lm: 8.31675 -- lightminute, a good default in-system unit ?
  pc2ly: 3.26156 -- parsec
}

range = 100

class System
  new: (@r) =>
    @rotationOffset = math.pi * 2 * love.math.random!
    @distanceOffset = love.math.randomNormal 0.26, 0
    -- minimum distance between systems is 14000 au (2x largest system discovered irl)
    if @distanceOffset > 0.5
      @distanceOffset = 0.5 - 7000 * units.au2ly
    elseif @distanceOffset < -0.5
      @distanceOffset = -0.5 + 7000 * units.au2ly

  draw: (time) =>
    love.graphics.points @getPosition time

  getPosition: (time) =>
    return @r * math.cos(time/(@r + @distanceOffset) + @rotationOffset), @r * math.sin(time/(@r + @distanceOffset) + @rotationOffset)

  -- this doesn't work without scale factor being part of this system instead of time itself moving slowly..
  -- getOrbitalPeriod: (printable) =>
  --   return math.pi * 2 / (@r + @distanceOffset)

galaxy.init = =>
  love.math.setRandomSeed os.time!
  galaxy.time = os.time!
  galaxy.speed = 0.03125

  -- galaxy.size = math.sqrt(w*w + h*h) / 2
  galaxy.size = 2000
  galaxy.systems = {}
  for i = 1, galaxy.size
    table.insert galaxy.systems, System i

  galaxy.selected = galaxy.systems[1 + math.floor love.math.random! * #galaxy.systems]
  -- galaxy.selected = galaxy.systems[1]

galaxy.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

camera = { x: 0, y: 0 }
galaxy.update = (dt) =>
  galaxy.time += dt * galaxy.speed

  if love.keyboard.isDown "up"
    camera.y -= 200 * dt
  if love.keyboard.isDown "down"
    camera.y += 200 * dt
  if love.keyboard.isDown "left"
    camera.x -= 200 * dt
  if love.keyboard.isDown "right"
    camera.x += 200 * dt

output = {}
galaxy.draw = =>
  systemsNearby = 0
  x, y = galaxy.selected\getPosition galaxy.time
  -- for system in *galaxy.systems
  --   a, b = system\getPosition galaxy.time
  --   r = math.sqrt (x - a)^2 + (y - b)^2
  --   if r < range
  --     systemsNearby += 1


  -- r = galaxy.selected.r
  -- output[r] = systemsNearby
  -- if r < galaxy.size - 101
  --   galaxy.selected = galaxy.systems[r + 1]

  size = 10000 -- random estimated "max" size
  love.graphics.print "Speed: #{galaxy.speed}\nFastest/Slowest full rotations: #{math.pi*2/galaxy.speed/60} min/#{math.pi*2/galaxy.speed*size/60/60/24} days\nSystem selected: #{galaxy.selected.r} Nearby systems: #{systemsNearby}", 1, 1

  love.graphics.translate w / 2 - camera.x, h / 2 - camera.y

  for system in *galaxy.systems
    system\draw galaxy.time

  -- x, y = galaxy.selected\getPosition galaxy.time
  -- love.graphics.rectangle "line", x - range, y - range, 100, 100
  love.graphics.circle "line", x, y, range

  -- generate lines network
  for i = 1, #galaxy.systems - 1
    x, y = galaxy.systems[i]\getPosition galaxy.time
    for j = i + 1, #galaxy.systems
      a, b = galaxy.systems[j]\getPosition galaxy.time
      r = math.sqrt (x - a)^2 + (y - b)^2
      if r < range
        love.graphics.line x, y, a, b

galaxy.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!
    when "-"
      galaxy.speed /= 2
    when "="
      galaxy.speed *= 2
    when "s"
      galaxy.selected = galaxy.systems[1 + math.floor love.math.random! * (#galaxy.systems - 101)]
    when "d"
      for k,v in pairs output
        print k,v
    -- when "up"
    --   camera.y -= 10

return galaxy
