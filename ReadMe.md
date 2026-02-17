# kiwenwan
I've wanted to make a space game for a decade. There are many experiments disorganized across various repos.

This *monolith* is an easy way for me to cross-pollinate ideas and prototypes into something more functional. It isn't intended to be easy to use, but to bring enough together to pull a game out of in the future.

## Prototypes

- 2d-map: Tile map experiment.
- 3rd-dimension: g3d demo.
- areatest: Another galaxy generator, with different sections of system density.
- buildmass: An experiment in mass-accumulation simulation to devise "realistic" star systems.
- colortest: Star colors?
- flightmodel: A space navigation experiment.
- galaxy: A dynamic generative galaxy, to be turned into a map for warp travel between star systems. Based entirely on time and procedural generation.
- lynx_testing: Testing the lynx UI library.
- menu: A menu for selecting which prototype to open.
- slab_testing: Testing Slab UI library. (NOTE: Not my slab library, someone else's.)
- system_view: A simplified system map viewer. To be filled with information someday.
- TEMPLATE: A template for making more prototypes.
- tinyclone: Nothing yet. Inspired by [Tiny Space Program](https://play.google.com/store/apps/details?id=com.companyname.Space_Program).

## Inspirations

- [Bussard](https://technomancy.itch.io/bussard) is "A space flight programming adventure game." similar to what I desire to make. Development stalled on it, but what exists is fun to play regardless.
- [Oolite](https://www.oolite.space/) is an open source reimplementation of the original Elite.
- [Transcendence](https://transcendence.kronosaur.com/). This game is formative, I played it in high school. (I've heard [Endless Sky](https://endless-sky.github.io/) and [Destination Sol](https://destinationsol.org/) are similar.)

## Libraries Used

- ftcsv: CSV parser/encoder. [From here](https://github.com/FourierTransformer/ftcsv).
- g3d: 3D rendering and collision detection. [From here](https://github.com/groverburger/g3d) ([docs](https://github.com/groverburger/g3d/wiki)).
- gamestate.lua: Easy state management.
  Currently maintained [here](https://github.com/HDictus/hump) ([docs](https://github.com/HDictus/hump/blob/temp-master/docs/gamestate.rst)). My version [is modified](https://github.com/TangentFoxy/kiwenwan/commit/0bf48908b21f25addf04ab197c6e807790da0512).
- json.lua: JSON parser/encoder. [From here](https://github.com/rxi/json.lua).
- lovebird: Browser-based debug console. [From here](https://github.com/rxi/lovebird).
- lume: Gamedev utility functions. [From here](https://github.com/TangentFoxy/lume).
- dkjson: JSON parser/encoder. Produces readible output. [From here](https://github.com/TangentFoxy/dkjson.lua).
