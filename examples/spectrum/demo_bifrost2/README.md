# ZX SPECTRUM BIFROST*2 DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/target/zx/bifrost2)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/clang/arch/zx/bifrost2.h)

Before using Bifrost*2, it should be configured.

The default configuration is:

* Animation size: 2 or 4 frames per animation group  
  `defc __BIFROST2_ANIM_GROUP = 4`
* First non-animated frame  
  `defc __BIFROST2_STATIC_MIN = 128`
* Value subtracted from non-animated frames  
  `defc __BIFROST2_STATIC_OVERLAP = 128`
* Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)  
  `defc __BIFROST2_TILE_IMAGES = 49000`
* Tile rendering order (1 for sequential, 7 or 9 for distributed)  
  `defc __BIFROST2_TILE_ORDER = 7`
* Location of the tile map (11x10=110 tiles)  
  `defc __BIFROST2_TILE_MAP = 65281`
* Number of char rows rendered in multicolor (3-22)  
  `define(\`__BIFROST2_TOTAL_ROWS', 22)`

This program assumes the default configuration so nothing needs to be done to configure the engine prior to compiling.

## Compile the Demo

This program can be compiled using the makefile.

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
20 LOAD "BIFROST2"CODE
30 LOAD ""CODE
40 RANDOMIZE USR VAL "32768"
```
