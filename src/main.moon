Gamestate = require "lib.gamestate"
menu = require "states.menu"

-- BYPASS MAIN MENU
priority = "slab_testing"

love.load = ->
  Gamestate.registerEvents!
  if priority
    Gamestate.switch require "states.#{priority}"
  else
    Gamestate.switch menu
