# kiwenwan
I've wanted to make a space game for a decade. There are many experiments disorganized across various repos.

This *monolith* is an easy way for me to cross-pollinate ideas and prototypes into something more functional. It isn't intended to be easy to use, but to bring enough together to pull a game out of in the future.

## Prototypes

- galaxy: A dynamic generative galaxy, to be turned into a map for warp travel between star systems. Based entirely on time and procedural generation.
- system_view: A simplified system map viewer. To be filled with information someday.
- tinyclone: Nothing yet. Inspired by [Tiny Space Program](https://play.google.com/store/apps/details?id=com.companyname.Space_Program).

## Libraries Used

- ftcsv: CSV parser/encoder. [From here](https://github.com/FourierTransformer/ftcsv).
- gamestate.lua: Easy state management.
  Currently maintained [here](https://github.com/HDictus/hump) ([docs](https://github.com/HDictus/hump/blob/temp-master/docs/gamestate.rst)). My version [is modified](https://github.com/TangentFoxy/kiwenwan/commit/0bf48908b21f25addf04ab197c6e807790da0512).
