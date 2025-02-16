Gamestate = require "lib.gamestate"
lynx_testing = {}
w, h = 960, 540

lynx = require "lib.lynx"

local menu

lynx_testing.init = =>
  menu = lynx.menu {
    lynx.text "Sample text 1",
    lynx.text "Sample text 2",
    lynx.text "Sample text 3",
    lynx.button "Simple hello button", ->
      print "Hello World !",
    {}
  }, {
    viewport: { 0, 0, 300, 200 },
    offset: { 0, 50 },
    default_height: 20,
    funcs: lynx.love_lynx
  }

lynx_testing.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

lynx_testing.update = (dt) =>
  menu\update dt

lynx_testing.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)

  menu\draw!

lynx_testing.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return lynx_testing
