Gamestate = require "lib.gamestate"
menu = require "states.menu"

-- BYPASS MAIN MENU
priority = "terrain"

priority = arg[2] if #arg == 2

love.load = ->
  Gamestate.registerEvents!
  if priority
    Gamestate.switch require "states.#{priority}"
  else
    Gamestate.switch menu
