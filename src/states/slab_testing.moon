Gamestate = require "lib.gamestate"
slab_testing = {}
w, h = 960, 540

Slab = require "lib.Slab"

slab_testing.init = =>
  Slab.Initialize!

slab_testing.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

slab_testing.update = (dt) =>
  Slab.Update dt

  Slab.BeginWindow "window id", { Title: "Displayed Title Text" }
  Slab.Text "Text being displayed inside the window!"
  Slab.EndWindow!

slab_testing.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

  Slab.Draw!

slab_testing.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return slab_testing
