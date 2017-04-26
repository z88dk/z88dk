# ZX SPECTRUM BIFROST_L DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/arch/zx/bifrost_l)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/bifrost_l.h)

Before using Bifrost_L, it should be configured.

The default configuration is:

 * Animation speed: 2 or 4 frames per second  
   `defc __BIFROSTL_ANIM_SPEED = 4`
 * Animation size: 2 or 4 frames per animation group  
   `defc __BIFROSTL_ANIM_GROUP = 4`
 * First non-animated frame  
   `defc __BIFROSTL_STATIC_MIN = 128`
 * Value subtracted from non-animated frames  
   `defc __BIFROSTL_STATIC_OVERLAP = 128`
 * Location of the tiles table (64 bytes per tile)  
   `defc __BIFROSTL_TILE_IMAGES = 48500`
 * Location of the tile map (9x9=81 tiles)  
   `defc __BIFROSTL_TILE_MAP = 65281`
 * Tile rendering order (1 for sequential, 7 for distributed)  
   `defc __BIFROSTL_TILE_ORDER = 7`

This program assumes the default configuration so nothing needs to be done to configure the engine prior to compiling.

## Bifrost_L Configuration

However in other circumstances, the bifrost_h target configuration file should be edited to change the settings
("z88dk/libsrc/_DEVELOPMENT/target/zx/config_bifrost_l.m4") and then the zx library should be rebuilt by running:

`Winmake zx` (windows)  
`make TARGET=zx` (other)

from the "z88dk/libsrc/_DEVELOPMENT" directory.

## Compile the Demo

This program can be compiled as follows:

1. SCCZ80 + New C Library
```
zcc +zx -vn -startup=1 -clib=new bifrostldem.c ctile.asm -o bifrostldem
appmake +zx -b bifrostldem_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname BIFROSTL
appmake +zx -b bifrostldem_CODE.bin -o bifrostldem.tap --noloader --org 32768 --blockname bifrostldem
copy /b loader.tap + bifrostl.tap + bifrostldem.tap demo.tap
```
2. ZSDCC + New C Library
```
zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 bifrostldem.c ctile.asm -o bifrostldem
appmake +zx -b bifrostldem_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname BIFROSTL
appmake +zx -b bifrostldem_CODE.bin -o bifrostldem.tap --noloader --org 32768 --blockname bifrostldem
copy /b loader.tap + bifrostl.tap + bifrostldem.tap demo.tap
```
After compiling, the binaries "bifrostldem_CODE.bin" (containing the program) and "bifrostldem_BIFROSTL.bin" (containing the bifrost_l engine) are produced.

Appmake is run to turn those into CODE-only tap files.

Windows "copy" is used to append those taps to the end of "loader.tap" to form the final tap file "demo.tap"

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
30 LOAD "BIFROSTL"CODE
40 LOAD ""CODE
50 RANDOMIZE USR VAL "32768"
```
