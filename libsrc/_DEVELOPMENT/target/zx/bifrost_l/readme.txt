=============================

BIFROST* ENGINE - RELEASE 1.2

=============================



The BIFROST* ENGINE provides Rainbow Graphics support by rendering 9x9 animated

multicolor tiles of 16x16 pixels each, without flickering.



The initial versions of this tool were originally based on the innovative ZXodus

Engine, but since BIFROST* code was rewritten on latest version, this is not the

case anymore. ZXodus made creating multicolor programs on the Spectrum 48K a lot

easier, implementing a tile map whose content is automatically generated on

screen between lines 1 to 18, columns 1 to 18. The BIFROST* ENGINE works in a

similar way, although providing additional features such as animated tiles.



Technically the BIFROST* ENGINE is intended to be flexible enough to support

creating programs somewhat similar to the revolutionary game BUZZSAW by Jason

Railton (joefish). It can combine static and animated multicolor tiles, and

allows developers to directly manipulate multicolor areas on screen in order to

create additional movements and special effects.



The current version is a "dual release", providing 2 variants:



* Variant "L" can directly draw tiles at "low-res" char rows on screen, using

"PRINT AT" coordinates (with regular tiles starting at rows 1,3,5..17). Thus

this variant is smaller and faster.



* Variant "H" can directly draw tiles at "hi-res" pixel lines on screen, using

"PLOT-like" coordinates (with regular tiles starting at lines 16,32,48...144

since BIFROST* pixel coordinates are counted starting 8 pixels above the

screen). Thus this variant is more versatile.



Most information in this document applies to both variants, except where

explicitly indicated otherwise.





=======

LICENSE

=======



You can freely use the BIFROST* ENGINE to develop your own programs (even for

commercial projects), as long as you clearly mention that it was developed using

the BIFROST* ENGINE. It doesn't matter how you choose to do so.



For instance, a concise way to respect the license would be simply including

something like this:



  Powered by BIFROST*



Or if you want to mention it in a game screen with limited space available, you 

can simply write somewhere:



  BIFROST*



You can also freely use R-Tape's tile images from this version of the demo,

provided you mention the BIFROST* ENGINE. Alternatively, if you are only using

these tile images but nothing else from the BIFROST* ENGINE, you may choose to

only credit R-Tape directly.





========

FEATURES

========



* Flexibility: Static and animated multicolor tiles can be used simultaneously,

and you also have the option to manipulate screens areas directly.



* No flickering: The BIFROST* ENGINE produces 18 columns of Rainbow Graphics

(multicolor) tiles without any kind of flickering, not even when executing BASIC

programs or running your Assembly code in contended memory.



* High performance: Although the Rainbow Graphics rendering requires a lot of

processing, the BIFROST* ENGINE makes your program "just" 3.5 times slower than

normal. This is still 75% faster than the ZXodus Engine (that makes programs 6

times slower than normal).



* Low delay: The entire tile map is updated to screen about 4 times per second

(more precisely 6 tiles per frame, thus 6x50/81=3.7 times per second). It means

that any change you make in the tile map takes only 135ms on average to appear

on screen. This is twice as fast than the ZXodus Engine.



* Customization: You can easily reconfigure it to choose animation size (2 or 4

frames) and speed (2 or 4 frames per second) for each animated tile. You can

also choose how many tile indexes are reserved for static and animated tiles,

and how these indexes "overlap" (see below).



* Compatibility: The BIFROST* ENGINE is compatible with the ZXodus Engine,

adopting the same tile images format and tile mapping mechanism. Thus it's easy

to switch engines if you find out later that your program needs a particular

feature (such as the ones listed above).



* Portability: The current version of the BIFROST* ENGINE supports all standard

Spectrum models (48K, 128K, +2, +2A, and +3).





============

INSTRUCTIONS

============



First you must protect the memory area using CLEAR, then load your tile images

and the BIFROST* ENGINE from tape. For instance:



  CLEAR 48499: LOAD "TILES" CODE: LOAD "BIFROST*" CODE



Afterwards there's no need to initialize anything. Simply activate multicolor

rendering using:



  RANDOMIZE NOT USR 64995



And deactivate it using:



  RANDOMIZE NOT USR 65012



I suggest using the NOT keyword as above to avoid resetting the RND sequence (if

you don't know what I mean, just trust me on this). Or you can simply CALL these

addresses directly in Assembly.



The BIFROST* ENGINE uses a tile map of 9x9=81 positions starting at address

65281. Whenever you POKE a tile index into the tile map, the corresponding

multicolor tile image will appear on screen. For instance:



  POKE 65281,0: POKE 65281+80,5



These statements above will make tile 0 appear at the top left corner of the

multicolor rendering area (first position), and tile 5 at the lower right corner

(last position).



By default, tiles are continuously animated in groups of 4. The first animation

group consists of tiles 0 to 3, second animation group of tiles 4 to 7, and so

on. Every .27 seconds, each tile map position is automatically updated to the

next tile number in the sequence. In the example above, position 65281 will

change to 1,2,3,0 and repeat this sequence, ad infinitum. At the same time,

position 65281+80 will be changed to 6,7,4,5 and so on.



Tile indexes 0 to 127 designate animated tiles. If you want to render a certain

tile image without animation, just add 128 to this number. In the previous

example, you can make tiles 0 and 5 remain forever on screen as follows:



  POKE 65281,128+0: POKE 65281+80,128+5



There's however an exception to this rule: if a tile map position contains the

special index 255, no tile will be mapped to screen at this position, although

the screen content will continue to be rendered in multicolor. It means you can

POKE value 255 into any position in the tile map, then change the screen bitmap

and multicolor attributes directly afterwards:



  POKE 65281,255: POKE 65281+80,255: ...





=============

CUSTOMIZATION

=============



Some global characteristics of the BIFROST* ENGINE can be customized by either

recompiling the code or POKEing these values directly in memory:



* Tiles are animated at 4 frames per second by default, but this can be reduced

to 2 frames per second (however reducing the animation speed won't affect the

delay between making changes to the tile map and they appearing on screen):



  POKE 59035,254: REM slow animations



  POKE 59035,198: REM fast animations



* Animated groups have 4 frames each by default, but this can be reduced to 2

frames per group:



[Variant "L"]:

  POKE 58780,0: POKE 58782,128: POKE 58783,0: REM 2 frames per animation

  POKE 58780,15: POKE 58782,64: POKE 58783,7: REM 4 frames per animation



[Variant "H"]:

  POKE 58698,0: POKE 58700,128: POKE 58701,0: REM 2 frames per animation

  POKE 58698,15: POKE 58700,64: POKE 58701,7: REM 4 frames per animation



* Tile images are stored starting at address 48500, but they can be relocated to

whatever address you want (even inside contended memory):



[Variant "L"]:

  POKE 58802,INT (addr/256): POKE 58801,addr-256*PEEK 58802: REM tile images



[Variant "H"]:

  POKE 58727,INT (addr/256): POKE 58726,addr-256*PEEK 58727: REM tile images



* The tile map accepts 255 different tile indexes (from 0 to 254, since index

255 is reserved as previously described). By default, the BIFROST* ENGINE is

configured with "static minimum" 128, i.e. tile index 128 or higher indicates a

non-animated tile. In these cases, you must subtract "static overlap" 128 from

the tile index to obtain the actual tile image. Thus tile index 128 will render

tile image 0, 129 will render tile image 1, and so on. As a consequence, you can

only have 128 different tile images, with 127 of them accessed as both animated

and static. If your program needs more tile images, and you don't need to render

all of them as both animated and static, you can reconfigure these parameters.

For instance, if you choose "static minimum" 160 and "static overlap" 55, then

tile indexes 0 to 159 will animate tile images 0 to 159 in 40 animation groups,

and tile indexes 160 to 255 will render static tile images from 160-55=105 to

255-55=200. Thus tile images from 105 to 159 will be available to be rendered as

either animated (indexes 105 to 159) or static (indexes 160 to 214). If these

settings seem too confusing just leave it alone, otherwise the "static minimum"

and "static overlap" can be reconfigured as follows:



[Variant "L"]:

  POKE 58768,min: POKE 58776,1+overlap: REM tile indexes



[Variant "H"]:

  POKE 58686,min: POKE 58694,1+overlap: REM tile indexes



The BIFROST* ENGINE must be disabled when reconfiguring it (except for changes

in animation speed that require a single POKE), otherwise it will generate some

garbage on screen or in the tile map (although it would not crash anything).





=============

DEMONSTRATION

=============



The BIFROST* ENGINE tape contains a very simple demo program in BASIC. At any

time you can press BREAK to interrupt this program, disable the BIFROST* ENGINE

executing RANDOMIZE NOT USR 65016, then take a look at the listing to see how it

works. The relevant lines are as follows:



* LINE 10: Load everything from tape

* LINE 40: Activate BIFROST* ENGINE

* LINE 50: Fill tile map with sequence of static tiles from 0 to 80

* LINE 80: Fill tile map with random static tiles from 8 to 33

* LINE 130: Reconfigure BIFROST* ENGINE to 2 frames per animation

* LINE 150: Reconfigure BIFROST* ENGINE back to 4 frames per animation

* LINE 170: Disable tile mapping at positions 40 and 41

* LINE 180: Directly modify screen bitmaps at positions 40 and 41

* LINE 190: Directly modify multicolor attributes at positions 40 and 41

* LINE 220: Place random animated tiles from 0 to 7 at random positions

* LINE 250: Reconfigure BIFROST* ENGINE to animate tiles at 2 frames per second

* LINE 260: Reconfigure BIFROST* ENGINE to animate tiles at 4 frames per second





==============

TECHNICALITIES

==============



When implementing your own program, it may seem confusing to manipulate tile map

positions that are continuously changing due to animation, but it's actually

quite easy. If a tile map position contains an animated tile, just divide it by

4 to obtain its animation group instead of the current animation frame, as

follows:



  LET a=PEEK 65281: IF a<128 THEN LET a=INT (a/4)



The BIFROST* ENGINE code ends at address 65280, and the tile map is located at

addresses 65281 to 65361. Since they do not interfere with the UDG area that is

usually located afterwards, there are no restrictions about redefining and using

UDG characters while the BIFROST* ENGINE is running.



Each tile occupies 64 bytes, storing 32 bytes of bitmap (16 pairs from top to

bottom) followed by 32 bytes of attributes (stored in the same order). After you

figure out how many tiles you will need in your program, it may be a good idea

to relocate tile images accordingly.



After POKEing value 255 at a tile map position, you will be able to directly

modify the corresponding bitmap information on screen as usual. However trying

to change screen attributes directly won't work since they are constantly

overwritten with multicolor, thus you will need to change the multicolor

attributes instead. In order to figure out the exact memory address to change,

keep in mind that multicolor is rendered from char rows 1 to 18 (thus pixel

lines 8+1*8=16 to 8+18*8+7=159, since BIFROST* pixel coordinates are counted

starting 8 pixels above the screen) and char columns 1 to 18, then apply the

following calculation:



  POKE 59075 + (line-16)*41 + delta, attrib



Value "delta" above depends on the char column to be changed, according to the

following table:



+--------+-------+

| column | delta |

+--------+-------+

|    1   |    4  |

|    2   |    5  |

|    3   |    7  |

|    4   |    8  |

|    5   |   10  |

|    6   |   11  |

|    7   |   14  |

|    8   |   15  |

|    9   |   17  |

|   10   |   18  |

|   11   |   32  |

|   12   |   33  |

|   13   |   28  |

|   14   |   29  |

|   15   |   24  |

|   16   |   25  |

|   17   |   20  |

|   18   |   21  |

+--------+-------+



For instance, if you want to change all 8 multicolor attributes corresponding to

PRINT AT 10,9 you can execute the following code:



  POKE 65281+40,255: LET delta=17: LET row=10

  FOR f=8+row*8 to 8+row*8+7: POKE 59075+(f-16)*41+delta,attrib: NEXT f



When you are directly changing the multicolor area, if you want all results to

appear at once, you can use instruction HALT just before starting your changes.

After this, you will have over 20K T-states to make your changes until the next

interrupt.



It's also convenient to use HALT just before using any routine that temporarily

disable interrupts (for instance sub-routine "putTile" from Boriel's ZX BASIC

standard library), thus hopefully there will be enough time to run the entire

routine without missing any interrupt. Otherwise the multicolor render won't be

called on certain frames and thus you will see some garbage quickly appearing on

screen.



By default, the BIFROST* ENGINE executes ROM routine $38 (the same as RST 38) at

every frame, right after the multicolor rendering has finished. If you need also

another interrupt routine (for instance to control AY sound), you can change the

BIFROST* ENGINE to execute your routine instead, then you can call routine $38

yourself afterwards. In this case, your routine will be called about 50 times

per second at exact intervals of 69888 T-states every time. Notice this interval

is even more precise than calling your interrupt routine directly from the

interrupt vector, since the BIFROST* ENGINE knows how to synchronize perfectly

with the TV raster beam to eliminate all interrupt variations and delays. The

address of your interrupt routine can be configured as follows:



  POKE 64994,INT (addr/256): POKE 64993,addr-256*PEEK 64994: REM interrupt addr





=========

RENDERING

=========



Even if you won't use tiles in your program, you can still take advantage of

BIFROST* ENGINE's ability to render multicolor attributes without flickering,

and code your own program to do everything else, manipulating screen bitmaps

and multicolor attributes directly.



The easiest way is to permanently fill the tile map area with special index 255.

In this case, the BIFROST* ENGINE won't draw any tiles, and it will simply busy

wait for over 14K T-states at every interrupt, until the TV raster beam finally

reaches the screen area (where multicolor render starts). Thus you won't need to

load any tile images in memory, so your program can use that area for something

else.



A more complex alternative is to develop your own Assembly code to replace the

tile mapping part of the BIFROST* ENGINE, so you can use this busy wait period

to do something more productive. Technically, it means you can replace the code

section from address 59031 to 59046 (between labels "tile_mapping_begin" and

"tile_mapping_end" in the source code) with whatever you want, as long as your

code always take EXACTLY 14008 T-states EVERY TIME, measured from start address

59031 to the following address 59047. This way, you will return control to the

BIFROST* ENGINE at the exact moment it needs to take over multicolor rendering.

Notice however that this alternative is not really recommended since it's hard

to write complex code where every execution path takes exactly the same time,

and the multicolor rendering probably won't work properly if you fail. Thus it's

better to use multicolor tiles whenever possible, and let the BIFROST* ENGINE

worry about all timing issues for you... But if you want to try anyway, the

following example shows how to replace the original tile mapping with a new code

that takes exactly 14008 T-states (although it doesn't do anything useful):



    org 59031

    ld bc,538      ;10 T

loop:

    dec bc         ;538*6 T

    ld a,b         ;538*4 T

    or c           ;538*4 T

    jr nz,loop     ;537*12+7 T

    ret nz         ;5 T

    jp 59047       ;10 T





====================

ADVANCED PROGRAMMING

====================



Drawing and animating tiles in BIFROST* ENGINE are typically automated, based on

changes to the tile map. Even so, sometimes programs may need to perform certain

operations "manually". For instance, a tile map update takes 135ms on average to

appear on screen, but if the player is moving a multicolor cursor on screen, it

could work better to draw and erase the cursor tile instantly.



For such cases, there are a few internal routines in BIFROST* ENGINE that can be

directly accessed from Assembly, or using the interface libraries provided for

Boriel's ZX BASIC and z88dk. Just don't bother trying to use them from regular

Sinclair BASIC programs, since in this case it would be faster to simply use the

automated tile mapping mechanism anyway...



However, using these internal routines is only recommended for experienced

programmers for the following reasons:





* Most internal routines can only be used with interrupts disabled. However, if

your program doesn't enable them again before the next frame, the entire screen

will be rendered without multicolor, thus you will see a "glitch". The best way

to avoid this problem is to use instructions 'HALT' and 'DI' at the beginning of

your routine, then you will have about 20K T-states available before you must

execute 'EI' on time to catch the next frame. More precisely, the BIFROST*

ENGINE interrupt finishes exactly 48265 T-states after each interrupt (including

the 'JP' instruction at address 64992), the ROM routine $38 may take another 1K

T-state, and the next interrupt will happen at 69888 T-states. The routines that

require disabling interrupts are indicated as "DI?" below:



[Variant "L"]:

+---------------+---------+----------+-----+-----------------------------------+

|  routine      | address | T-states | DI? | description                       |

+---------------+---------+----------+-----+-----------------------------------+

| draw_tile     |  58786  |   1482   | yes | Instantly draw tile A at row D,   |

|               |         |          |     | col E on screen                   |

+---------------+---------+----------+-----+-----------------------------------+

| show_tile_pos |  58754  |   1582   | yes | Instantly show/animate tile map   |

|               |         |          |     | position at row D, col E on screen|

+---------------+---------+----------+-----+-----------------------------------+

| show_next_tile|  58727  |   1689   | yes | Instantly show/animate next tile  |

|               |         |          |     | map position in drawing order     |

+---------------+---------+----------+-----+-----------------------------------+

| fill_tile_attr|  58661  |    798   | no  | Instantly fill the tile attributes|

|               |         |    (*)   |     | at row D, col E with value C      |

+---------------+---------+----------+-----+-----------------------------------+



[Variant "H"]:

+---------------+---------+----------+-----+-----------------------------------+

|  routine      | address | T-states | DI? | description                       |

+---------------+---------+----------+-----+-----------------------------------+

| draw_tile     |  58704  |odd   2110| yes | Instantly draw tile A at row D,   |

|               |         |even<=2730|     | col E on screen                   |

+---------------+---------+----------+-----+-----------------------------------+

| show_tile_pos |  58672  |   2210   | yes | Instantly show/animate tile map   |

|               |         |          |     | position at row D, col E on screen|

+---------------+---------+----------+-----+-----------------------------------+

| show_next_tile|  58642  |   2308   | yes | Instantly show/animate next tile  |

|               |         |          |     | map position in drawing order     |

+---------------+---------+----------+-----+-----------------------------------+

| fill_tile_attr|  57109  |    895   | yes | Instantly fill the tile attributes|

|               |         |          |     | at row D, col E with value C      |

+---------------+---------+----------+-----+-----------------------------------+

| draw_tile_pos |  57082  | <=2235   | yes | Instantly redraw tile map position|

|               |         |          |     | at row D, col E or fill with C    |

+---------------+---------+----------+-----+-----------------------------------+

|draw_back_tiles|  57047  |1pos<=2294| yes | Instantly redraw all tile map     |

|               |         |4pos<=9254|     | positions behind a tile at row D, |

|               |         |          |     | col E, or fill with value C if 255|

+---------------+---------+----------+-----+-----------------------------------+





* Although regular functionality uses "abstract" coordinates i.e. tile positions

at positions (px,py) numbered from 0 to 8, the internal routines listed above

use "low-res" coordinates (row,col) in variant "L", and "hi-res" coordinates

(lin,col) in variant "H", which may seem confusing. The next section provides

further details about this subject.





* These variants have slightly different restrictions regarding tile positions.

In variant "L", routine 'draw_tile' will only work for odd columns (1,3,5..17)

and require the entire tile to fit on the multicolor area (rows 1 to 17). In

variant "H", this routine will work for any position immediately above or below

the screen (lines 0 to 160) and for any column from 0 to 18 (although at columns

0 and 18 the tile will appear halfway outside the multicolor area, in this case

it's recommended to previously paint columns 0 and 19 with the same INK/PAPER on

both sides in the regular screen to hide this).





It's also important to use these routines correctly, otherwise whatever your

program "manually" draws on the screen will be lost when the BIFROST* ENGINE

"automatically" redraws the same position based on the tile map. The recommended

approach to use these routines is as follows:



* 'draw_tile': Use it when you need to instantly draw static tiles on screen,

  for instance to move a multicolor cursor. In this case, set the corresponding

  tile map position to value 255 first, so it will never interfere. This routine

  can also draw a tile at an even row (between 2 regular tile map positions), in

  this case just don't forget to set both tile map positions to 255 first.



* 'show_tile_pos': Use it when you need to instantly draw animated tiles on

  screen, for instance to make an animated monster appear. In this case, set the

  corresponding tile map position to the animated tile, then call this routine

  to show the following frame on screen instantly. The following frames will be

  animated automatically afterwards.



* 'show_next_tile': Use it if you want to update the entire multicolor area

  faster. The BIFROST* ENGINE executes it automatically 6 times per frame, in

  20K T-states there's enough time to call this routine "manually" another 11

  times per frame. This way, the multicolor area will be fully updated after

  5 frames, thus almost 3 times faster than normal.



* 'fill_tile_attr': Use it to quickly set an entire tile to a single color (for

  instance to paint it red on black to indicate that it was "selected" somehow)

  or to erase it (for instance paint it black on black to make it "disappear").

  In variant "L", this routine was optimized for size instead of speed since it

  was already fast enough, however if you need it to run even faster, you can

  just copy it to another area in your program using an "unrolled" loop at the

  end, which will make it 210 T-states faster.



* 'draw_tile_pos': Use it when you need to instantly redraw an specific tile map

  position, for instance if you just moved (or removed) another tile previously

  in front of this position. This routine is somewhat similar to 'show_tile_pos'

  except it won't animate tiles (it will simply redraw the current tile frame)

  and, if the tile map position contains 255, it will "erase" this position on

  screen by filling its attributes with the value provided in register C. This

  routine is only available in variant "H" and it takes at most 2235 T-states

  to execute.



* 'draw_back_tiles': Use it when you need to instantly redraw all tile map

  positions behind some tile that you just "manually" moved (or removed) on

  screen. In practice, this routine may execute 'draw_tile_pos' at most 4 times,

  taking up to 9254 T-states in the worst case. Notice that, if this routine is

  called for a position that perfectly matches a standard tile position, this

  routine will execute 'draw_tile_pos' only once, taking at most 2294 T-states.

  This routine is only available in variant "H" also.





================

TILE COORDINATES

================



As mentioned in the previous section, regular functionality in BIFROST* ENGINE

uses "abstract" positions (px,py) although internal routines use "low-res"

coordinates (row,col) in variant "L" and "hi-res" coordinates (lin,col) in

variant "H".



The following diagrams illustrate all 3 coordinate systems:





  "Abstract" positions (px,py) simply reference the tiles in sequential order:



          0   1   2   3   4   5   6   7   8  py

        +---+---+---+---+---+---+---+---+---+

      0 | 00| 01| 02| 03| 04| 05| 06| 07| 08|

        +---+---+---+---+---+---+---+---+---+

      1 | 09| 10| 11| 12| 13| 14| 15| 16| 17|

        +---+---+---+---+---+---+---+---+---+

      2 | 18| 19| 20| 21| 22| 23| 24| 25| 26|

        +---+---+---+---+---+---+---+---+---+

      3 | 27| 28| 29| 30| 31| 32| 33| 34| 35|

        +---+---+---+---+---+---+---+---+---+

      4 | 36| 37| 38| 39| 40| 41| 42| 43| 44|

        +---+---+---+---+---+---+---+---+---+

      5 | 45| 46| 47| 48| 49| 50| 51| 52| 53|

        +---+---+---+---+---+---+---+---+---+

      6 | 54| 55| 56| 57| 58| 59| 60| 61| 62|

        +---+---+---+---+---+---+---+---+---+

      7 | 63| 64| 65| 66| 67| 68| 69| 70| 71|

        +---+---+---+---+---+---+---+---+---+

      8 | 72| 73| 74| 75| 76| 77| 78| 79| 80|

        +---+---+---+---+---+---+---+---+---+

      px





  "Low-res" tile positions reference the rows and columns according to their

"PRINT AT" coordinates on screen:



         01    03    05    07    09    11    13    15    17    col

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     01 | 0   | 0   | 0   | 0   | 0   | 0   | 0   | 0   | 0   |

        |   0 |   1 |   2 |   3 |   4 |   5 |   6 |   7 |   8 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     03 | 0   | 1   | 1   | 1   | 1   | 1   | 1   | 1   | 1   |

        |   9 |   0 |   1 |   2 |   3 |   4 |   5 |   6 |   7 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     05 | 1   | 1   | 2   | 2   | 2   | 2   | 2   | 2   | 2   |

        |   8 |   9 |   0 |   1 |   2 |   3 |   4 |   5 |   6 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     07 | 2   | 2   | 2   | 3   | 3   | 3   | 3   | 3   | 3   |

        |   7 |   8 |   9 |   0 |   1 |   2 |   3 |   4 |   5 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     09 | 3   | 3   | 3   | 3   | 4   | 4   | 4   | 4   | 4   |

        |   6 |   7 |   8 |   9 |   0 |   1 |   2 |   3 |   4 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     11 | 4   | 4   | 4   | 4   | 4   | 5   | 5   | 5   | 5   |

        |   5 |   6 |   7 |   8 |   9 |   0 |   1 |   2 |   3 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     13 | 5   | 5   | 5   | 5   | 5   | 5   | 6   | 6   | 6   |

        |   4 |   5 |   6 |   7 |   8 |   9 |   0 |   1 |   2 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     15 | 6   | 6   | 6   | 6   | 6   | 6   | 6   | 7   | 7   |

        |   3 |   4 |   5 |   6 |   7 |   8 |   9 |   0 |   1 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     17 | 7   | 7   | 7   | 7   | 7   | 7   | 7   | 7   | 8   |

        |   2 |   3 |   4 |   5 |   6 |   7 |   8 |   9 |   0 |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     row





  "Hi-res" tile counts pixel lines as if starting 8 pixels above the screen,

thus allowing a 16x16 tile to move as gradually entering the multicolor area

from above and exiting below (or vice-versa):



         01    03    05    07    09    11    13    15    17    col

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     16 |     |     |     |     |     |     |     |     |     |

        | 0 0 | 0 1 | 0 2 | 0 3 | 0 4 | 0 5 | 0 6 | 0 7 | 0 8 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     32 |     |     |     |     |     |     |     |     |     |

        | 0 9 | 1 0 | 1 1 | 1 2 | 1 3 | 1 4 | 1 5 | 1 6 | 1 7 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     48 |     |     |     |     |     |     |     |     |     |

        | 1 8 | 1 9 | 2 0 | 2 1 | 2 2 | 2 3 | 2 4 | 2 5 | 2 6 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     64 |     |     |     |     |     |     |     |     |     |

        | 2 7 | 2 8 | 2 9 | 3 0 | 3 1 | 3 2 | 3 3 | 3 4 | 3 5 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     80 |     |     |     |     |     |     |     |     |     |

        | 3 6 | 3 7 | 3 8 | 3 9 | 4 0 | 4 1 | 4 2 | 4 3 | 4 4 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

     96 |     |     |     |     |     |     |     |     |     |

        | 4 5 | 4 6 | 4 7 | 4 8 | 4 9 | 5 0 | 5 1 | 5 2 | 5 3 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

    112 |     |     |     |     |     |     |     |     |     |

        | 5 4 | 5 5 | 5 6 | 5 7 | 5 8 | 5 9 | 6 0 | 6 1 | 6 2 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

    128 |     |     |     |     |     |     |     |     |     |

        | 6 3 | 6 4 | 6 5 | 6 6 | 6 7 | 6 8 | 6 9 | 7 0 | 7 1 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

    144 |     |     |     |     |     |     |     |     |     |

        | 7 2 | 7 3 | 7 4 | 7 5 | 7 6 | 7 7 | 7 8 | 7 9 | 8 0 |

        |     |     |     |     |     |     |     |     |     |

        +-----+-----+-----+-----+-----+-----+-----+-----+-----+

    lin





In practice, you should simply choose the most detailed coordinate system you

need, use it for all variables in your program, then convert to less detailed

coordinates whenever necessary. Typical situations are:



* If you don't need to access the internal routines, just use "abstract"

positions (px,py) all the time.



* If you need to use internal routines from variant "L", use "low-res" tile

positions (row,col) all the time (converted to "abstract" as needed).



* If you need to use internal routines from variant "H", use "hi-res" tile

positions (lin,col) all the time (converted to "abstract" as needed).





Converting tile positions between coordinate systems requires just a few

operations, according to the following tables:





  Converting px/row/lin "rounded" up:



                   FROM +---------------+---------------+---------------+

      TO                | "abstract" px | "low-res" row | "hi-res" lin  |

        +---------------+---------------+---------------+---------------+

        | "abstract" px |      ==       |    row>>1     |  (lin>>4)-1   |

        +---------------+---------------+---------------+---------------+

        | "low-res" row |   (px<<1)+1   |      ==       |  (lin>>3)-1   |

        +---------------+---------------+---------------+---------------+

        | "hi-res" lin  |   (px+1)<<4   |  (row+1)<<3   |      ==       |

        +---------------+---------------+---------------+---------------+





  Converting px/row/lin "rounded" down:



                   FROM +---------------+---------------+---------------+

      TO                | "abstract" px | "low-res" row | "hi-res" lin  |

        +---------------+---------------+---------------+---------------+

        | "abstract" px |      ==       |  (row-1)>>1   |  (lin-1)>>4   |

        +---------------+---------------+---------------+---------------+

        | "low-res" row |   (px<<1)+1   |      ==       |  (lin-1)>>3   |

        +---------------+---------------+---------------+---------------+

        | "hi-res" lin  |   (px+1)<<4   |  (row+1)<<3   |      ==       |

        +---------------+---------------+---------------+---------------+





  Converting py/col "rounded" to the left:



                   FROM +---------------+---------------+---------------+

      TO                | "abstract" py | "low-res" col | "hi-res" col  |

        +---------------+---------------+---------------+---------------+

        | "abstract" py |      ==       |  (col-1)>>1   |  (col-1)>>1   |

        +---------------+---------------+---------------+---------------+

        | "low-res" col |   (py<<1)+1   |      ==       |      ==       |

        +---------------+---------------+---------------+---------------+

        | "hi-res" col  |   (py<<1)+1   |      ==       |      ==       |

        +---------------+---------------+---------------+---------------+





  Converting py/col "rounded" to the right:



                   FROM +---------------+---------------+---------------+

      TO                | "abstract" py | "low-res" col | "hi-res" col  |

        +---------------+---------------+---------------+---------------+

        | "abstract" py |       ==      |    col>>1     |    col>>1     |

        +---------------+---------------+---------------+---------------+

        | "low-res" col |   (py<<1)+1   |      ==       |      ==       |

        +---------------+---------------+---------------+---------------+

        | "hi-res" col  |   (py<<1)+1   |      ==       |      ==       |

        +---------------+---------------+---------------+---------------+





=================

BORIEL'S ZX BASIC

=================



Although all instructions above also work for programs developed using Boriel's

ZX BASIC, in this case it's easier (and more efficient) to use interface library

"bifrost.bas" instead. Just copy this file to the same folder where you compile

your program and use the provided sub-routines, just like in the sample program

"bifrostdem.bas" that works as follows:



    #include "bifrost.bas"



    BIFROSTstart()

    ...

    BIFROSTsetTile(row, column, index)



Afterwards compile your program as usual:



    zxb.exe bifrostdem.bas -T -B



The command above will compile your program starting at default memory address

32768, and generate a tape file called "bifrostdem.tzx". To run it, edit the

BASIC loader program to load on memory the tile images, the BIFROST* ENGINE and

your compiled program, as follows:



    10 CLEAR 32767

    20 LOAD "TILES"CODE

    30 LOAD "BIFROST*"CODE

    40 LOAD "bifrostdem"CODE

    50 RANDOMIZE USR 32768



Notice the first 2 blocks can be copied from the original BIFROST* ENGINE tape.

If you design your own set of multicolor tiles, just save it on tape instead of

"TILES". Also if you load it at a different address than default 48500, don't

forget to call sub-routine "BIFROSTresetTileImages(addr)" to configure this

address before calling "BIFROSTstart()".



Also notice each BIFROST* variant ("L" or "H") has a different interface library

thus you must be careful to use the correct files. Finally notice the routines

adopt a name convention based on their parameters:



* Function names ending with "L" require a "low-res" coordinate (row,col) with 

tiles starting at rows 1,3,5..17 and columns 1,3,5..17

* Function names ending with "H" require a "hi-res" coordinate (lin,col) with

tiles starting at lines 16,32,48...144 and columns 1,3,5..17

* The remaining cases either require an "abstract" position (px,py) with tiles

at abstract positions 0,1,2..8; or none.





=====

Z88DK

=====



Although all instructions above also work for programs developed using z88dk, in

this case it's easier (and more efficient) to use interface library "bifrost.h"

and "bifrost.lib" instead. Just copy both files to the same folder where you

compile your program and use the provided sub-routines, just like in the sample

program "bifrostdem.c" that works as follows:



    #include "bifrost.h"



    BIFROST_start()

    ...

    BIFROST_setTile(row, column, index)



Afterwards compile your program using the interface library, for instance:



    zcc.exe +zx -lm -lndos -lbifrost -create-app bifrostdem.c -obifrostdem.bin



The command above will compile your program starting at default memory address

32768, and generate a tape file called "bifrostdem.tap". To run it, edit the

BASIC loader program to load on memory the tile images, the BIFROST* ENGINE and

your compiled program, as follows:



    10 CLEAR VAL "32767"

    20 LOAD "TILES"CODE

    30 LOAD "BIFROST*"CODE

    40 LOAD "bifrostdem"CODE

    50 RANDOMIZE USR VAL "32768"



Notice the first 2 blocks can be copied from the original BIFROST* ENGINE tape.

If you design your own set of multicolor tiles, just save it on tape instead of

"TILES". Also if you load it at a different address than default 48500, don't

forget to call sub-routine "BIFROST_resetTileImages(addr)" to configure this

address before calling "BIFROST_start()".



Also notice each BIFROST* variant ("L" or "H") has a different interface library

thus you must be careful to use the correct files. Finally notice the routines

adopt a name convention based on their parameters:



* Function names ending with "L" require a "low-res" coordinate (row,col) with

tiles starting at rows 1,3,5..17 and columns 1,3,5..17

* Function names ending with "H" require a "hi-res" coordinate (lin,col) with

tiles starting at lines 16,32,48...144 and columns 1,3,5..17

* The remaining cases either require an "abstract" position (px,py) with tiles

at abstract positions 0,1,2..8; or none.





=============

SPECTRUM 128K

=============



The BIFROST* ENGINE ensures perfect synchronization with the TV raster beam in

all standard Spectrum models (48K, 128K, +2, +2A, and +3), taking into account

the particularities between different Spectrum 128 variations. This is important

because multicolor rendering is very sensitive to timing issues: running the

multicolor render just a couple T-states out-of-sync would be enough to produce

visible flickering, typically appearing on the last column (if it runs a little

too early) or the first column (if a little too late). In order to avoid this

problem, the BIFROST* ENGINE now implements a dual anti-flickering mechanism

(one execution path supporting the Spectrum 48K model and another supporting all

Spectrum 128 variants) that is automatically selected, so you don't need to do

worry yourself about supporting Spectrum 128 models.



However, you must be aware of 2 requirements related to Spectrum 128 machines:



* Programs developed in Sinclair BASIC using multicolor should not be executed

in 128 BASIC mode (either from "Tape Loader" or "128 BASIC" options from the

start menu). They should always run in Spectrum 48K mode, even on Spectrum 128

models. The problem is that 128 BASIC disables interrupts frequently (especially

when switching ROM's) when running Sinclair BASIC programs, thus missing a few

interrupt frames. When it happens, the entire multicolor area "glitches" due to

the missing frame. Since the multicolor render is not even called in this case,

there's nothing it can do to prevent this problem. The only solution is always

loading Sinclair BASIC programs in Spectrum 48K mode, by either choosing option

"48 BASIC" from the start menu, or executing command "SPECTRUM", or running

"RANDOMIZE USR 0" before loading the program. If you are planning to distribute

your own program programmed in Sinclair BASIC using multicolor, I suggest saving

on tape a copy of utility "Usr0x01" (that can be downloaded from this link:

http://www.worldofspectrum.org/infoseekid.cgi?id=0027522 ) just before your own

program. This utility will automatically change mode as needed, then load your

program afterwards, so your end users won't have to do anything different than

usual. Fortunately this restriction only applies to Sinclair BASIC programs. In

case of compiled programs (with z88dk or Boriel's ZX BASIC), or programs created

directly in Assembly, they are not affected by this 128 BASIC behavior so there

will be no special requirements.



* Keep in mind that the BIFROST* ENGINE interrupt code runs in memory page RAM0.

If you are developing a program especifically for Spectrum 128 machines and need

to page another RAM bank, remember to deactivate the BIFROST* ENGINE before

paging, and only re-activate it after restoring page RAM0 again!





=======

HISTORY

=======



* Version 1.0 (2012-03-04) - Initial release (ZX-Spectrum 48K only).



* Version 1.1 (2012-04-15) - Added support for all standard ZX-Spectrum models.



* Version 1.2 (2012-07-15) - Optimized version with extended functionality.





=======

CREDITS

=======



BIFROST* ENGINE designed and implemented by

  Einar Saukas.



Demo multicolor tiles created by

  Dave Hughes (R-Tape).



Inspired by game BUZZSAW by

  Jason J. Railton (joefish).



Original 18 columns multicolor method by

  Matt Westcott (gasman) and AMW.

