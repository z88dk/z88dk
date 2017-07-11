# ZX SPECTRUM BIFROST_H DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/arch/zx/bifrost_h)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/bifrost_h.h)

The examples from the author's tutorial series "Bifrost* Advanced Programming" have been updated and reproduced here.

Before using Bifrost_H, it should be configured.

The default configuration is:

 * Animation speed: 2 or 4 frames per second  
   `defc __BIFROSTH_ANIM_SPEED = 4`
 * Animation size: 2 or 4 frames per animation group  
   `defc __BIFROSTH_ANIM_GROUP = 4`
 * First non-animated frame  
   `defc __BIFROSTH_STATIC_MIN = 128`
 * Value subtracted from non-animated frames  
   `defc __BIFROSTH_STATIC_OVERLAP = 128`
 * Location of the tiles table (64 bytes per tile)  
   `defc __BIFROSTH_TILE_IMAGES = 48500`
 * Location of the tile map (9x9=81 tiles)  
   `defc __BIFROSTH_TILE_MAP = 65281`
 * Tile rendering order (1 for sequential, 7 for distributed)  
   `defc __BIFROSTH_TILE_ORDER = 7`
 * Shift screen coordinates by 0 or 4 columns to the right  
   `defc __BIFROSTH_SHIFT_COLUMNS = 0`
 * Render special sprite tiles every frame?  
   `defc __BIFROSTH_SPRITE_MODE = 0`

This program assumes the default configuration so nothing needs to be done to configure the engine prior to compiling.

## Bifrost_H Configuration

However in other circumstances, the bifrost_h target configuration file should be edited to change the settings
("z88dk/libsrc/_DEVELOPMENT/target/zx/config/config_bifrost_h.m4") and then the zx library should be rebuilt by running:

`Winmake zx` (windows)  
`make TARGET=zx` (other)

from the "z88dk/libsrc/_DEVELOPMENT" directory.

## Compile the Demo

This program can be compiled as follows:

1. SCCZ80 + New C Library
```
zcc +zx -vn -startup=1 -clib=new bifrosthdem.c ctile.asm -o bifrosthdem
appmake +zx -b bifrosthdem_BIFROSTH.bin -o bifrosth.tap --noloader --org 57047 --blockname BIFROSTH
appmake +zx -b bifrosthdem_CODE.bin -o bifrosthdem.tap --noloader --org 32768 --blockname bifrosthdem
copy /b loader.tap + bifrosth.tap + bifrosthdem.tap demo.tap
```
2. ZSDCC + New C Library
```
zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 bifrosthdem.c ctile.asm -o bifrosthdem
appmake +zx -b bifrosthdem_BIFROSTH.bin -o bifrosth.tap --noloader --org 57047 --blockname BIFROSTH
appmake +zx -b bifrosthdem_CODE.bin -o bifrosthdem.tap --noloader --org 32768 --blockname bifrosthdem
copy /b loader.tap + bifrosth.tap + bifrosthdem.tap demo.tap
```
After compiling, the binaries "bifrosthdem_CODE.bin" (containing the program) and "bifrosthdem_BIFROSTH.bin" (containing the bifrost_h engine) are produced.

Appmake is run to turn those into CODE-only tap files.

Windows "copy" is used to append those taps to the end of "loader.tap" to form the final tap file "demo.tap"

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
30 LOAD "BIFROSTH"CODE
40 LOAD ""CODE
50 RANDOMIZE USR VAL "32768"
```
