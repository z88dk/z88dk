==================================
BIFROST*2 ENGINE - by Einar Saukas
==================================

The BIFROST*2 ENGINE provides Rainbow Graphics support for 20 columns (at most
22 rows) in multicolor 8x1, by rendering animated multicolor tiles with 16x16
pixels each, without flickering.

It can combine static and animated multicolor tiles, supports all standard
ZX-Spectrum models, and allows developers to directly manipulate multicolor 
areas on screen in order to create additional movements and special effects.


=======
LICENSE
=======

You can freely use the BIFROST*2 ENGINE to develop your own programs (even for
commercial projects), as long as you clearly mention that it was developed using
the BIFROST*2 ENGINE. It doesn't matter how you choose to do so.

For instance, a concise way to respect the license would be simply including
something like this:

  Powered by BIFROST*2

Or if you want to mention it in a game screen with limited space available, you
can simply write somewhere:

  BIFROST*2


========
FEATURES
========

* Flexibility: Static and animated multicolor tiles can be used simultaneously,
and you also have the option to manipulate screens areas directly.

* No flickering: The BIFROST*2 ENGINE produces 20 columns of Rainbow Graphics
(multicolor) tiles without any kind of flickering, not even when executing BASIC
programs or running your Assembly code in contended memory.

* High performance: Although the Rainbow Graphics rendering requires a lot of
processing, the BIFROST*2 ENGINE makes your program "just" a few times slower
than normal (depending on how many multicolor rows you are using).

* Low delay: The entire tile map is updated to screen over 2 times per second
(more precisely 5 tiles per frame, thus 5x50/110=2.3 times per second, or faster
depending on number of multicolor rows). It means that any change you make in
the tile map takes only 220ms on average (or faster) to appear on screen.

* Customization: You can easily reconfigure it to choose animation size (2 or 4
frames) for each animated tile. You can also choose how many multicolor rows you
want on screen, how many tile indexes are reserved for static and animated 
tiles, and how these indexes "overlap".

* Compatibility: The BIFROST*2 ENGINE is compatible with BIFROST* and ZXodus,
adopting the same tile images format and tile mapping mechanism.

* Portability: The BIFROST*2 ENGINE supports all standard ZX-Spectrum models
(48K, 128K, +2, +2A, and +3).


============
INSTRUCTIONS
============

Right after loading, the BIFROST*2 ENGINE must be installed first, before it can
be used. The installation routine will auto-detect current ZX-Spectrum model and
reconfigure itself accordingly. It must be called only once. After installation,
you are free to modify the tile map area or use other BIFROST*2 routines.

Multicolor tiles are rendered based on a tile map with at most 11x10 positions
starting at address 65281. Whenever you "poke" a tile index into the tile map,
the corresponding multicolor tile image will appear on screen.

By default, tiles are continuously animated in groups of 4. The first animation
group consists of tiles 0 to 3, second animation group of tiles 4 to 7, and so
on. Every .44 seconds, each tile map position is automatically updated to the
next tile number in the sequence.

Tile indexes 0 to 127 designate animated tiles. If you want to render a certain
tile image without animation, just add 128 to this number. There's however an
exception to this rule: if a tile map position contains the special index 255,
no tile will be mapped to screen at this position, although the screen content
will continue to be rendered in multicolor. It means you can "poke" value 255
into any position in the tile map, then change the screen bitmap and multicolor
attributes directly using all other BIFROST*2 routines.

Don't forget to start the BIFROST*2 ENGINE in order to make your changes appear
on screen.


=============
CUSTOMIZATION
=============

Most BIFROST*2 ENGINE characteristics can be configured in runtime. In order to
use it, you just need to compile your program using an appropriate interface
library (currently available for Boriel's ZX BASIC and z88dk), then load the
BIFROST*2 ENGINE separately and install it. A version of the BIFROST*2 ENGINE
compiled with all default settings is available inside the demo tape file.

However, if you want to modify the number of multicolor rows, you will have to
recompile the BIFROST*2 ENGINE, as follows:

1.) Extract contents of file "BIFROST2_SourceCode.zip"

2.) Download file "pasmo-0.5.4.beta2.zip" from Pasmo page, then extract file
    "pasmo.exe" to the same directory;

3.) Download file "ZX7_(WindowsExecutable).zip" from ZX7 page, then extract file
    "zx7.exe" to the same directory;

4.) Download file "ZX7_SourceCode.zip" from ZX7 page, then extract file
    "dzx7_turbo.asm" to the same directory;

5.) Edit file "BIFROST2_CONFIG.asm" to modify number of multicolor rows, and
    other default parameters as needed.

Afterwards, double-click on file "compile.bat" to recompile BIFROST*2. If you
have properly followed all instructions above, this will generate a new file
"BIFROST2.tap" in the same directory, containing the modified engine.

After installation, if the BIFROST*2 ENGINE was recompiled to use less than 22
char rows, then memory area from address (56567+TOTAL_ROWS*376) to address 64828
can be reused for something else.


====================
ADVANCED PROGRAMMING
====================

Drawing and animating tiles in BIFROST*2 ENGINE are typically automated, based
on changes to the tile map. Even so, programs may need to perform certain
operations "manually". For instance, a tile map update may take up to 440 ms
(220 ms on average) to appear on screen, but if the player is moving a
multicolor cursor on screen, it could work better to draw and erase the cursor
tile instantly.

For such cases, there are a few internal routines in BIFROST*2 ENGINE that can
be used directly. Just make sure they finish executing before the next interrupt
occurs, otherwise your program will crash (if interrupts are enabled) or glitch
(otherwise). Routine timings are:

+---------------+---------+----------------+-----------------------------------+
|  routine      | address |  T-states      |  description                      |
+---------------+---------+----------------+-----------------------------------+
| show_next_tile|  51653  |      1946      | Instantly show/animate next tile  |
|               |         |                | map position in drawing order     |
+---------------+---------+----------------+-----------------------------------+
| show_tile_pos |  51683  |      1848      | Instantly show/animate tile map   |
|               |         |                | position at row D, col E on screen|
+---------------+---------+----------------+-----------------------------------+
| draw_tile     |  51714  | zero col: 1643 | Instantly draw tile A at row D,   |
|               |         |  odd col: 1752 | col E on screen                   |
|               |         | even col: 2306 |                                   |
|               |         | last col: 1757 |                                   |
+---------------+---------+----------------+-----------------------------------+
| fill_tile_attr|  64829  | zero col:  459 | Instantly fill the tile attributes|
|               |         |  odd col:  622 | at row D, col E with value C      |
|               |         | even col:  859 |                                   |
|               |         | last col:  571 |                                   |
+---------------+---------+----------------+-----------------------------------+


================
TILE COORDINATES
================

BIFROST*2 ENGINE routines that access tile map positions reference "abstract"
coordinates (px,py). BIFROST*2 ENGINE routines that manipulate screen directly
reference "hi-res" coordinates (lin,col).

The following diagrams illustrate these coordinate systems:


  "Abstract" positions (px,py) simply reference the tiles in sequential order:

          0   1   2   3   4   5   6   7   8   9  py
        +---+---+---+---+---+---+---+---+---+---+
      0 | 00| 01| 02| 03| 04| 05| 06| 07| 08| 09|
        +---+---+---+---+---+---+---+---+---+---+
      1 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19|
        +---+---+---+---+---+---+---+---+---+---+
      2 | 20| 21| 22| 23| 24| 25| 26| 27| 28| 29|
        +---+---+---+---+---+---+---+---+---+---+
      3 | 30| 31| 32| 33| 34| 35| 36| 37| 38| 39|
        +---+---+---+---+---+---+---+---+---+---+
      4 | 40| 41| 42| 43| 44| 45| 46| 47| 48| 49|
        +---+---+---+---+---+---+---+---+---+---+
      5 | 50| 51| 52| 53| 54| 55| 56| 57| 58| 59|
        +---+---+---+---+---+---+---+---+---+---+
      6 | 60| 61| 62| 63| 64| 65| 66| 67| 68| 69|
        +---+---+---+---+---+---+---+---+---+---+
      7 | 70| 71| 72| 73| 74| 75| 76| 77| 78| 79|
        +---+---+---+---+---+---+---+---+---+---+
      8 | 80| 81| 82| 83| 84| 85| 86| 87| 88| 89|
        +---+---+---+---+---+---+---+---+---+---+
      9 | 90| 91| 92| 93| 94| 95| 96| 97| 98| 99|
        +---+---+---+---+---+---+---+---+---+---+
     10 |100|101|102|103|104|105|106|107|108|109|
        +---+---+---+---+---+---+---+---+---+---+
      px


  "Hi-res" positions (lin,col) reference tile coordinates as if starting 8
pixels above the screen, thus allowing a 16x16 tile to be moved partially 
appearing/disappearing at top or bottom of screen:

         01    03    05    07    09    11    13    15    17    19    col
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     16 |     |     |     |     |     |     |     |     |     |     |
        | 0 0 | 0 1 | 0 2 | 0 3 | 0 4 | 0 5 | 0 6 | 0 7 | 0 8 | 0 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     32 |     |     |     |     |     |     |     |     |     |     |
        | 1 0 | 1 1 | 1 2 | 1 3 | 1 4 | 1 5 | 1 6 | 1 7 | 1 8 | 1 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     48 |     |     |     |     |     |     |     |     |     |     |
        | 2 0 | 2 1 | 2 2 | 2 3 | 2 4 | 2 5 | 2 6 | 2 7 | 2 8 | 2 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     64 |     |     |     |     |     |     |     |     |     |     |
        | 3 0 | 3 1 | 3 2 | 3 3 | 3 4 | 3 5 | 3 6 | 3 7 | 3 8 | 3 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     80 |     |     |     |     |     |     |     |     |     |     |
        | 4 0 | 4 1 | 4 2 | 4 3 | 4 4 | 4 5 | 4 6 | 4 7 | 4 8 | 4 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
     96 |     |     |     |     |     |     |     |     |     |     |
        | 5 0 | 5 1 | 5 2 | 5 3 | 5 4 | 5 5 | 5 6 | 5 7 | 5 8 | 5 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    112 |     |     |     |     |     |     |     |     |     |     |
        | 6 0 | 6 1 | 6 2 | 6 3 | 6 4 | 6 5 | 6 6 | 6 7 | 6 8 | 6 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    128 |     |     |     |     |     |     |     |     |     |     |
        | 7 0 | 7 1 | 7 2 | 7 3 | 7 4 | 7 5 | 7 6 | 7 7 | 7 8 | 7 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    144 |     |     |     |     |     |     |     |     |     |     |
        | 8 0 | 8 1 | 8 2 | 8 3 | 8 4 | 8 5 | 8 6 | 8 7 | 8 8 | 8 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    160 |     |     |     |     |     |     |     |     |     |     |
        | 9 0 | 9 1 | 9 2 | 9 3 | 9 4 | 9 5 | 9 6 | 9 7 | 9 8 | 9 9 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    176 |     |     |     |     |     |     |     |     |     |     |
        | 100 | 101 | 102 | 103 | 104 | 105 | 106 | 107 | 108 | 109 |
        |     |     |     |     |     |     |     |     |     |     |
        +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    lin


=======
CREDITS
=======

BIFROST*2 ENGINE designed and implemented by
  Einar Saukas.

Based on 20 columns multicolor 8x1 method suggested by
  Matt Westcott (gasman) and developed by Einar Saukas.
