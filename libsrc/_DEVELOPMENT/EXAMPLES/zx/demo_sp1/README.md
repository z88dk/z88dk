# ZX SPECTRUM SP1 SPRITE ENGINE

SP1 has been around in one form another for at least 15 years and in that time around 30-40 games have been written for it or its predecessor SPLIB2.  Some recent games include [Ninjajar](http://www.mojontwins.com/juegos_mojonos/ninjajar/), [Forest Raider Cherry](http://www.worldofspectrum.org/infoseekid.cgi?id=0025408) and [Sgt Helmet Zero](http://www.mojontwins.com/juegos_mojonos/sgt-helmet-zero/). 

It is a sophisticated engine that is not completely documented, however if you are familiar with how many game consoles worked in the mid 1980s with their background tiles and sprites, SP1 works in a similar manner.

* [Brief Overview of the Engine](https://www.z88dk.org/wiki/doku.php?id=library:sprites:sp1)
* [Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/sp1.h)
* [Discussion of SP1's Memory Map and Configuration](https://www.z88dk.org/wiki/doku.php?id=libnew:examples:sp1_ex1)  
SP1 configuration is now done through z88dk/libsrc/_DEVELOPMENT/target/zx/config_sp1.m4
* [Set of Old Tutorial Programs](https://github.com/z88dk/z88dk/tree/master/libsrc/sprites/software/sp1/spectrum/examples) showing how part of the SP1 library works.  
  I am a little hesitant to link these because Z88DK has been simplified since then so these programs will not compile as-is.  Changes concern how SP1 allocates memory (it is now implied to be through malloc/free) and how data is defined in asm (it should be done in a separate .asm file).  The ideas and API calls are the same so seeing these examples and reading the comments in the .c source should be of value to understand how things work.

## Helpful Tools

SP1 understands two kinds of graphics - background tiles and sprites.

**Tiles** are simply UDGs so the usual graphics tools can be used for that.  An automatic one you may want to check into is [png2c.py](https://www.usebox.net/jjm/zxdev/).  This tool also seems to generate `sp1_PrintString()` strings to draw a complete screen.  `sp1_PrintString()` understands [control codes](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/temp/sp1/zx/tiles/SP1PrintString.asm#L20) in strings like repeat, move relative and so on that can describe a complete background screen in a compact manner.

**Sprites**, on the other hand, are defined in an unusual manner.  First of all, the engine is character oriented so all dimensions are measured in characters.  Sprite graphics are arranged in columns of a certain character height.  This is why sprites are built using `sp1_CreateSpr()` to create the first column (and specify the height) and then further columns are added with `sp1_AddColSpr()`.

Each column must have a single blank character below it as well as 7 blank pixel rows above.  Drawing your sprites such that they have a blank character row below will satisfy these requirements.  If the columns are stored one after the other, the blank row of a column above the current one will act as the 7 blank pixel rows it needs.  The first column defined should have 7 blank pixel rows added by hand above it.  So if you have a 3 character high by 2 character wide sprite, you should define it as 4 characters high and 2 characters wide with the last row kept blank.  If your graphics do not occupy the full 24 pixels high and 16 pixels wide for a 3x2 sprite you can tell the sprite engine this in the sprite definition so that it does not draw extra character squares needlessly.  If you always keep sprites on exact horizontal character coordinates you can choose a draw type that does not do sprite shifting.  If you always keep sprites on an exact vertical character coordinate you can eliminate the blank row below the columns.  These are very brief guidlines; ask more detailed questions on the [z88dk forum](https://www.z88dk.org/forum/forums.php).

There are a few tools available that will generate SP1 sprites:

* [SevenuP](http://metalbrain.speccy.org/) with the following settings (for non-masked sprites eliminate the mask):
  * ;Sort Priorities: Mask, Char line, Y char, X char
  * ;Data Outputted:  Gfx
  * ;Interleave:      Sprite
  * ;Mask:            Yes, before graphic
* [png2sprite.py](https://www.usebox.net/jjm/zxdev/)
* [TommyGun](https://worldofspectrum.org/forums/discussion/52390/tommygun-update) also has a SevenuP plug-in for its image editor.
