Gamestate = require "lib.gamestate"
areatest = {}
w, h = 960, 540

systems = {}
areatest.init = =>
  math.randomseed os.time!
  radius = 1000

  rings = {}
  for i = 0, radius + 1 -- intentionally including out of scope by 1 in case I messed up the scope
    rings[i] = 0

  for i = 1, 20000
    -- from https://stackoverflow.com/a/5838055
    t = math.random! * math.pi * 2
    u = math.random! + math.random!
    r = u
    r = 2 - u if u > 1
    r2 = r * radius
    x, y = r2 * math.cos(t), r2 * math.sin(t)
    table.insert(systems, {:x, :y, r: r2, a: t})
    rings[math.floor(r2)] += 1

  export max_ring, which_ring = 0, -1 -- fucking ridiculously lazy :D
  for i = 0, radius + 1
    ring = rings[i]
    if ring > max_ring
      max_ring = ring
      which_ring = i

areatest.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

areatest.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)
  love.graphics.print "Radius #{which_ring} has #{max_ring} systems.", 1, h - (fontSize + 1) * 2

  love.graphics.translate w / 2, h / 2
  for system in *systems
    love.graphics.points system.x, system.y

areatest.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return areatest
