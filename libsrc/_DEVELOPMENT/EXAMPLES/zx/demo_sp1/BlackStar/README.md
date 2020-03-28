# Black Star by Juan J. Martinez (@reidrac)
[Original Website](https://www.usebox.net/jjm/blackstar/)

This is a game I made in (less than) 48 hours for [BitBitJam 2015](http://bitbitjam.com/), a retro compo to make a game for an old 8-bit or 16-bit platform (in this edition the time limit was 48 hours).

I targeted the ZX Spectrum 48K and the theme was "Confronted Kingdoms". The result is Black Star, a Space Invaders type of game, that won in the "best platform use" category.

## License

The loading screen is based on Angelo Nero's "rainbow wormhole".

This bundle includes some third party code that has its own license, for
the rest the following applies.

Copyright (C) 2015 by Juan J. Martinez - www.usebox.net

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Compiling

`sccz80` compile (change copy to equivalent cat for non-windows)
~~~
zcc +zx -v -startup=31 -DWFRAMES=3 -clib=new -O3 @zproject.lst -o blackstar -pragma-include:zpragma.inc
appmake +zx -b loading.scr -o screen.tap --blockname screen --org 16384 --noloader
appmake +zx -b blackstar_CODE.bin -o game.tap --blockname game --org 25124 --noloader
copy /b loader.tap + screen.tap + game.tap blackstar.tap
~~~
`zsdcc` compile (optimization is high so compile time will be long)
~~~
zcc +zx -v -startup=31 -DWFRAMES=3 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --fsigned-char @zproject.lst -o blackstar -pragma-include:zpragma.inc
appmake +zx -b loading.scr -o screen.tap --blockname screen --org 16384 --noloader
appmake +zx -b blackstar_CODE.bin -o game.tap --blockname game --org 25124 --noloader
copy /b loader.tap + screen.tap + game.tap blackstar.tap
~~~
Some flags you may want to add to the compile line:
* -m  Creates a map file showing where everything is in memory
* --list  Shows the C source after it has been translated to asm by the compiler
* --c-code-in-asm  Will intersperse C code as comments in the list file
* -vn  Makes `zcc` quiet

### Notes

* Compile time options are communicated to `zcc` via pragmas which are stored in the file "zpragma.inc".  There are a lot of options; [these ones](https://www.z88dk.org/wiki/doku.php?id=libnew:target_embedded#crt_configuration) are generic for all targets and then the spectrum has more defined specifically for it.  The main ones of interest here are `CRT_ORG_CODE` which sets the ORG address, `REGISTER_SP` which sets the initial stack location in agreement with suggestions from the [default SP1 memory map](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/target/zx/config_sp1.m4#L34), and `CLIB_BALLOC_TABLE_SIZE` which tells the crt to create a block memory allocator with one queue.

* The list of files to compile is stored in "zproject.lst".  When there are a lot of source files, this is more convenient than listing each one individually on the compile line.  `zcc` is able to compile anything so the list of files can contain .c, .asm, .o, .m4 macros, etc.  The list can also contain other list files.  This method of compiling builds everything all the time.  Of course, incremental compiles are possible using a Makefile and generating .o as intermediate step per normal.  When using `zsdcc` as compiler this will almost always be needed as `zsdcc` can be quite slow on reasonably sized projects.

* `zcc` is not asked to automatically create a tap file (there is no "-create-app" option) because something more is needed in this case.  `zcc` creates the output binary "blackstar_CODE.bin" and then `appmake` is used to create a CODE .tap fragment out of it and the loading screen.  Tap files can be concatenated together so the full tap is formed by appending the .tap files together in the right order.  The basic loader is first and is kept in "loader.tap".  You can see the basic loader it contains below.  This file can be created in an emulator or by using a text to basic utility like "bas2tap".
```
10 BORDER 0: PAPER 0: INK 0: CLS : CLEAR 24099: POKE 23739,111: LOAD ""SCREEN$ : LOAD ""CODE : RANDOMIZE USR 25124
```

* Graphics are held in the `gfx` subdirectory.  There are two kinds of graphics here: tiles and sprites.  Tiles are simply UDGs.  Sprites are defined in columns and may have a mask byte interspersed with the graphics if the sprite is mask type, as they are in this program.  A condition that SP1 places on sprite graphics for proper display with vertical pixel resolution is that each sprite column must have 7 rows of blanks above and 8 below.  This is easy to share amongst multiple sprite columns by listing sprite column graphics one after the other so that the 7 blank rows above a sprite column can be shared with the 8 blanks below another.  The sprite graphics in this project are stored individually in files "bomber.asm", "explosion.asm", "flyer.asm", "impact.asm" and "player.asm".  You will see that 8 blank rows are added above "impact.asm" to make sure the player bullets display properly.   This may sound complicated to someone new to SP1 but the short of it is, draw your sprites with one blank character row below and all will be good.
* The author has python scripts that automatically generate tile and sprite graphics from .png.  You should click on the original website to learn more if you are interested in that.  Another tool that is capable of generating SP1 sprites is [SevenuP](http://metalbrain.speccy.org/).  The author's python tools actually generate header files containing C-declared char arrays to hold the raw data.  This is not the best format for graphics for two reasons.  One is that code or data should never be present in a C header file.  The char array generated should be in a .c file with corresponding .h informing the compiler of its existence.  Two is that from assembler there is much finer control over section assignment.  This will become important if you plan to generate programs for bankswitched memory.  For this commit, I used the author's tools to create the header files and then some cut & paste magic was performed to move the data into asm files.
* The original implementation used an external compressor called `ucl` to compress graphics and songs.  That was changed to `zx7` for convenience since that is built into `z88dk`.

## Programming Tips & Pitfalls
* One bug was corrected in the original program.  In several places strings were being defined with embedded control codes specified in hex, for example: "\x14\x471 KEYBOARD".  Can you spot the error?  In C, hex constants are read greedily so the two hex constants seen are "\x14" and "\x471".  To fix that, separate the two strings:  "\x14\x47" "1 KEYBOARD".  The author's compile worked because at that time `sccz80` did not process hex strings properly.
* The author adopted an advanced memory allocation strategy.  SP1 will acquire memory through `malloc` and `free` implicitly.  The author intercepts those calls to use the block memory allocator (balloc) instead.  The [block memory allocator](https://en.wikipedia.org/wiki/Memory_management#Fixed-size_blocks_allocation) is very fast and efficient in memory allocation; its only limitation is that it can only allocate fixed size blocks from each of its queues.  The author creates one queue and places 24-byte blocks into it.  This is the maximum size allocation request that SP1 will generate.  See "main.asm" to see how SP1's calls to `asm_malloc` and `asm_free` are intercepted.
* The original implementation attempted to control the compile sequence so that some things were preferentially placed in contended memory.  This will no longer work since `z88dk` has moved to a section model where a memory map is defined as a composition of sections and code and data are placed in sections which the linker will map to memory addresses according to the memory map.  In other words, compile sequence has no effect on placement in memory; only allocation to sections does.  An older commit of this example created a custom memory map with a CONTENDED section that was placed low in memory to copy the author's original intent.  The game works fine without doing this so this was removed to simplify the example.  But you can have a look by [investigating an earlier commit](https://github.com/z88dk/z88dk/tree/e2eac792363174e0171ab1a7cb622fd59570360e/libsrc/_DEVELOPMENT/EXAMPLES/zx/demo_sp1/BlackStar).  The key is an option in "zpragma.inc" to tell `zcc` to use user-supplied "mmap.inc" to define the memory map.
* When using "clib=sdcc_iy" compiles, `zsdcc` is being given a C library that is created with the IX and IY registers swapped.  If you are writing assembly language and calling into the library with parameters in IX or IY, they too will need to be swapped.  This is explained in "playfx.asm".
