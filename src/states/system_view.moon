Gamestate = require "lib.gamestate"
system_view = {}
w, h = 960, 540

-- types: stellar, gaseous, rocky, icy
-- rocky can be asteroid (0.5), moon (1), planet (2-3)
--  stupid temp name "rockmoon" in use
-- gaseous can be 5-7 (giant set to 6, gaseous set to 6)
-- stellar can be 10-20 (set to 15 along with primary)
-- fragment -> 1 (a type of rocky or whatever)
-- FUTURE: Use a logarithm of size instead of pre-set sizes

class Body
  new: (@type) =>
    @position = { 0, 0, 1 } -- x, y, radius
    @children = {}
    switch @type
      when "primary", "stellar"
        @position[3] = 15
      when "giant", "gaseous"
        @position[3] = 6
      when "rocky", "rockmoon"
        @position[3] = 2
      when "fragment"
        @position[3] = 1

  addChild: (child) =>
    child.position[1] = @position[1]
    child.position[2] = @position[2]
    offset = @position[3] + 1 + child.position[3]
    for body in *@children
      offset += body.position[3] * 2 + 1
    switch @type
      when "primary", "gaseous", "rockmoon"
        child.position[1] += offset
      when "giant", "rocky"
        child.position[2] += offset
    table.insert @children, child

local system
system_view.init = =>
  love.math.setRandomSeed os.time!

  system = {}
  -- star_count = math.floor math.max 1, love.math.randomNormal 1, 2
  star_count = 1
  for i = 1, star_count
    star = Body "primary"
    table.insert system, star
    planet_count = math.floor math.max 0, love.math.randomNormal 11/4, 10
    for i = 1, planet_count
      local planet
      if love.math.random! < 0.7
        planet = Body "giant"
      else
        planet = Body "rocky"
      star\addChild planet
      table.insert system, planet
      moon_count = math.floor math.max 0, love.math.randomNormal 5/4, 3
      for i = 1, moon_count
        local moon
        switch planet.type
          when "giant"
            if love.math.random! < 0.7
              moon = Body "fragment"
            else
              moon = Body "rockmoon"
          when "rocky"
            moon = Body "fragment"
        planet\addChild moon
        table.insert system, moon
        if moon.type == "rockmoon"
          if love.math.random! < 0.1
            moon2 = Body "fragment"
            moon\addChild moon2
            table.insert system, moon2

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
