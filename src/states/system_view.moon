Gamestate = require "lib.gamestate"
system_view = {}
w, h = 960, 540

-- types: stellar, gaseous, rocky, icy,

-- class Body
--   new: (@parent, type) =>
--     @children = {}
--     if @parent
--       switch @parent.type
--         when "star"
--           planet_count = math.floor math.max 0, love.math.randomNormal 11/4, 10
--           while planet_count > 0
--             -- TODO create and add planets to ourself
--             table.insert @children, Body(@, "rocky")
--         when "gaseous" -- "and icy?"
--           -- temporarily cannot have moon moons
--           moon_count = math.floor math.max 0, love.math.randomNormal 6/4, 5

class Body
  new: (@parent, @type) =>
    switch @type
      when "stellar"
        @radius = 3
      when "gaseous"
        @radius = 2
      when "rocky"
        @radius = 1
      else
        @radius = 1

  getPosition: =>
    x, y = 0, 0
    if @parent
      x, y = @parent\getPosition!
      switch @parent.type
        when "stellar", "gaseous", "icy"
          x += @parent.radius*2 + 1
        when "rocky"
          y += @parent.radius*2 + 1
        else
          x += @parent.radius*2 + 1
          y += @parent.radius*2 + 1
    return x, y

local system
system_view.init = =>
  love.math.setRandomSeed os.time!

  system = {}
  -- star_count = math.floor math.max 1, love.math.randomNormal 1, 2
  star_count = 1
  for i = 1, star_count
    star = Body nil, "stellar"
    -- star = { type: "star" }
    table.insert system, star
    planet_count = math.floor math.max 0, love.math.randomNormal 11/4, 10
    print "Planets: #{planet_count}"
    for i = 1, planet_count
      -- planet = { type: "rocky", parent: star }
      planet = Body star, "rocky"
      table.insert system, planet

system_view.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

system_view.draw = =>
  love.graphics.scale 10, 10

  for body in *system
    x, y = body\getPosition!
    love.graphics.circle "fill", x, y, body.radius

system_view.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!
    when "g"
      system_view\init!

return system_view
