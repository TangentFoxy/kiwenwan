Gamestate = require "lib.gamestate"
dimension = {}
w, h = 960, 540

local earth, moon, background, center_body
g3d = require "lib.g3d"

gravity = (A, B, dt) ->
  xDelta = A.location[1] - B.location[1]
  yDelta = A.location[2] - B.location[2]
  zDelta = A.location[3] - B.location[3]
  distance2 = xDelta^2 + yDelta^2 + zDelta^2
  distance = math.sqrt distance2
  force = 1 / distance2 -- future: needs to account for mass
  unit_vector = { xDelta / force, yDelta / force, zDelta / force } -- how the fuck is that supposed to account for things correctly?
  B.veolcity[1] += unit_vector[1] / dt / 100000
  B.veolcity[2] += unit_vector[2] / dt / 100000
  B.veolcity[3] += unit_vector[3] / dt / 100000

  -- okay fuck all of this, gonna try a thing
  -- -- distance = math.sqrt distance2
  -- force = 1 / distance2
  -- -- FIXME this is ignoring direction
  -- xDelta = force / xDelta
  -- yDelta = force / yDelta
  -- zDelta = force / zDelta
  -- B.veolcity[1] -= xDelta / dt
  -- B.veolcity[2] -= yDelta / dt
  -- B.veolcity[3] -= zDelta / dt

bodies = {}
dimension.init = =>
  love.math.setRandomSeed os.time!
  g3d.camera.aspectRatio = w / h
  g3d.camera.updateProjectionMatrix!

  earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {4,0,0})
  moon = g3d.newModel("assets/sphere.obj", "assets/moon.png", {4,5,0}, nil, 0.5)
  background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", nil, nil, 500)

  center_body = { location: {0,0,0}, veolcity: {0,0,0} }
  for i = 1, 10
    body = { location: { love.math.random! * 10, love.math.random! * 10, love.math.random! * 10 }, veolcity: { love.math.random! * 10, love.math.random! * 10, love.math.random! * 10 } }
    body.model = g3d.newModel "assets/sphere.obj", "assets/moon.png", body.location, nil, love.math.random!
    table.insert bodies, body

dimension.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

timer = 0
dimension.update = (dt) =>
  timer += dt
  moon\setTranslation math.cos(timer) * 5 + 4, math.sin(timer) * 5, 0
  moon\setRotation 0, 0, timer - math.pi / 2
  g3d.camera.firstPersonMovement dt

  for body in *bodies
    gravity center_body, body, dt

  for body in *bodies
    body.location[1] += body.veolcity[1] / dt / 1000000
    body.location[2] += body.veolcity[2] / dt / 1000000
    body.location[3] += body.veolcity[3] / dt / 1000000
    body.model\setTranslation unpack body.location

dimension.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)
  loc = bodies[1].location
  love.graphics.print "#{loc[1]}, #{loc[2]}, #{loc[3]}", 1, 1

  earth\draw!
  -- moon\draw!
  -- background\draw!

  for body in *bodies
    body.model\draw!

dimension.mousemoved = (x, y, dx, dy) =>
  g3d.camera.firstPersonLook dx, dy

dimension.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return dimension
