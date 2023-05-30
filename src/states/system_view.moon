Gamestate = require "lib.gamestate"
system_view = {}
w, h = 960, 540

-- types: stellar, gaseous, rocky, icy
-- rocky can be asteroid (0.5), moon (1), planet (2-3)
-- gaseous can be 5-7
-- stellar can be 10-20

class Body
  new: (@type) =>
    @position = { 0, 0, 1 } -- x, y, radius
    @children = {}
    switch @type
      when "stellar"
        @position[3] = 15
      when "gaseous"
        @position[3] = 6
      when "rocky"
        @position[3] = 2

  addChild: (child) =>
    child.position[1] = @position[1]
    child.position[2] = @position[2]
    offset = @position[3] + 1 + child.position[3]
    for body in *@children
      offset += body.position[3] * 2 + 1
    switch @type
      when "stellar", "gaseous", "icy"
        child.position[1] += offset
      when "rocky"
        child.position[2] += offset
    table.insert @children, child

local system
system_view.init = =>
  love.math.setRandomSeed os.time!

  system = {}
  -- star_count = math.floor math.max 1, love.math.randomNormal 1, 2
  star_count = 1
  for i = 1, star_count
    star = Body "stellar"
    table.insert system, star
    planet_count = math.floor math.max 0, love.math.randomNormal 11/4, 10
    print "Planets: #{planet_count}"
    for i = 1, planet_count
      local planet
      -- planet = Body "rocky"
      if love.math.random! < 0.7
        planet = Body "gaseous"
      else
        planet = Body "rocky"
      star\addChild planet
      table.insert system, planet

  -- for body in *system
  --   print unpack body.position

system_view.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

system_view.draw = =>
  scale = 5
  love.graphics.scale scale, scale

  for body in *system
    love.graphics.circle "fill", unpack body.position

system_view.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!
    when "g"
      system_view\init!

return system_view
