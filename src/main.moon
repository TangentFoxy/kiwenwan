Gamestate = require "lib.gamestate"
menu = require "states.menu"

love.load = ->
  Gamestate.registerEvents!
  Gamestate.switch menu
