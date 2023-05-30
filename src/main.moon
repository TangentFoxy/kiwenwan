Gamestate = require "lib.gamestate"
menu = require "states.menu"

-- BYPASS MAIN MENU
priority = "system_view"

love.load = ->
  Gamestate.registerEvents!
  if priority
    Gamestate.switch require "states.#{priority}"
  else
    Gamestate.switch menu
