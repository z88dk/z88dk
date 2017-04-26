# ZX SPECTRUM BIFROST*2 DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/arch/zx/bifrost2)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/bifrost2.h)

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

## Bifrost*2 Configuration

However in other circumstances, the bifrost*2 target configuration file should be edited to change the settings
("z88dk/libsrc/_DEVELOPMENT/target/zx/config_bifrost_2.m4") and then the zx library should be rebuilt by running:

`Winmake zx` (windows)  
`make TARGET=zx` (other)

from the "z88dk/libsrc/_DEVELOPMENT" directory.

## Compile the Demo

This program can be compiled as follows:

1. SCCZ80 + New C Library
```
zcc +zx -vn -startup=1 -clib=new bifrost2dem.c ctile.asm -o bifrost2dem
appmake +zx -b bifrost2dem_BIFROST2.bin -o bifrost2.tap --noloader --org 51625 --blockname BIFROST2
appmake +zx -b bifrost2dem_CODE.bin -o bifrost2dem.tap --noloader --org 32768 --blockname bifrost2dm
copy /b loader.tap + bifrost2.tap + bifrost2dem.tap demo.tap
```
2. ZSDCC + New C Library
```
zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 bifrost2dem.c ctile.asm -o bifrost2dem
appmake +zx -b bifrost2dem_BIFROST2.bin -o bifrost2.tap --noloader --org 51625 --blockname BIFROST2
appmake +zx -b bifrost2dem_CODE.bin -o bifrost2dem.tap --noloader --org 32768 --blockname bifrost2dm
copy /b loader.tap + bifrost2.tap + bifrost2dem.tap demo.tap
```
After compiling, the binaries "bifrost2dem_CODE.bin" (containing the program) and "bifrost2dem_BIFROST2.bin" (containing the bifrost*2 engine) are produced.

Appmake is run to turn those into CODE-only tap files.

Windows "copy" is used to append those taps to the end of "loader.tap" to form the final tap file "demo.tap"

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
20 LOAD "BIFROST2"CODE
30 LOAD ""CODE
40 RANDOMIZE USR VAL "32768"
```
