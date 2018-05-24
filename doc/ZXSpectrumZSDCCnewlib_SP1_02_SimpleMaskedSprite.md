# ZX Spectrum Development with C, Z88DK and SP1 - Simple Masked Sprite

This document describes how a ZX Spectrum developer can use the SP1 sprite
library to place a masked sprite on screen. It follows on from the [first
document](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md)
in the series, which the reader is assumed to have read.

This document is part of the [ZX Spectrum Z88DK/C developer's getting
started guide](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_GettingStartedGuide.md).

## Purpose

The SP1 library supports a number of ways of merging sprite data into the
Spectrum's display, the simplest of which, just loading the data straight into
video memory regardless of what's already there, was discussed in the [first SP1
article](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md)
in this series. The other modes are simple enough for the reader to
explore on their own, but how SP1 deals with masked sprites is worthy of
investigation.

## Assumptions

The reader is expected to be following on from the first SP1 document, and to
have read the other documents in the Getting Started series. In particular, this
document makes use of the Spectrum's interrupt, and the reader is assumed to
understand how Z88DK can set up the interrupt for custom use. This is covered in
depth in the [interrupts article](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_08_Interrupts.md).

## The Display Background

The principle of masked sprites is one all Spectrum programmers should be
familiar with. The basic idea is succinctly described
[here](http://www.breakintoprogram.co.uk/software_development/masking-sprites). Before
we look at a sprite, however, we need to take a brief look at the *background*.

SP1 needs to know what graphical information is in the background which the
sprites will float over. It is, after all, responsible for merging the sprite
graphics into that background, then restoring the background when the sprite
changes position. In fact, SP1 doesn't just *know* what's in the background,
it actually *controls* the background just as much as it controls the sprites in
the foreground. It's all part and parcel of the same display, and SP1 controls
all of it.

We're going to postpone discussion of how to get proper control over the
background until a later article, but in order to demonstrate how masked sprites
work we need to at least fill a pattern into the display background so we can
see the effects of the masking. We can create such a pattern by using a default
*tile* when we first initialise the screen.

---

**_This section introduces the SP1 concept of 'tiles'. If you've already read
the
[BiFrost](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_07_BiFrost.md)
part of this guide you'll know that BiFrost also has the concept of
'tiles'. It's somewhat unfortunate and confusing that the two graphics libraries
use the same term for different things. As we're about to see, SP1 uses the term
'tile' for an 8x8 pixel character cell, a grid of which makes up the background
SP1 draws onto. BiFrost uses the term 'tile' for a 16x16 pixel graphical object
which it can place on the screen.  If you're already familiar with BiFrost, make
sure you keep the concepts of 'tiles' separate in your head. They're different
entities in these two libraries._**

---

The SP1 display background is split up into a grid of 8x8 pixel *tiles*, each
one containing either a text character or a custom 8x8 graphic character which
Spectrum developers would identify as a traditional user defined graphic
(UDG). How these characters get into the grid of tiles, and how they are
manipulated once there, will be discussed in a later article. For now we just
need to populate the tiles with something so we can experiment with the
sprite masking. Fortunately there's an easy way to do this.

In the first article in this SP1 getting started series we looked at a [small
program](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#program-1---sp1-circle-sprite)
which initialises the SP1 library with this line of code:

```
sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                INK_BLACK | PAPER_WHITE,
                ' ' );
```

The last argument in that function call is the important one here. It specifies
a character value to fill the SP1 display area's tiles with. In this example it
uses the space character (the data comes from the character set in the
Spectrum's ROM) which has the effect of clearing the screen. For the purposes of
this guide, we're going to change this line to:

```
sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                INK_BLACK | PAPER_WHITE,
                'X' );
```

which will fill the display area with Xs. It's not particularly useful, but it
does fill the screen with a repeating pattern which is what we need here.

### The Sprite Data

Recall from the first article in this series that we used a simple 8x8 [circle
graphic](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#program-1---sp1-circle-sprite)
as our sprite, and that the data for it was defined in assembly language
as opposed to 'C' in order to make the graphical data a little easier to look
at. We're going to continue with that approach. For our masked sprite we'll use
the same circle sprite and a mask for it, as seen here, circle to the left, mask
to the right:

```
  1111     11    11
 1    1    1      1
1      1           
1      1           
1      1           
1      1           
 1    1    1      1
  1111     11    11

```

SP1 masks have a bit set where the background is to be allowed to be seen. This
mask just opens up the corners of the sprite; we could allow the centre of the
circle to show the background if we so chose.

As we've [seen](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#a-closer-look-at-the-sprites-code), in SP1 sprites are built up in columns, and our simple 8x8 pixel
sprite is one column of data. With masked sprites, the data is arranged in
memory as one mask byte, followed by one data byte, incrementing upwards in
memory. That gives this assembly listing:

```
SECTION rodata_user

PUBLIC _circle_masked

	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000

._circle_masked
	defb @11000011, @00111100
	defb @10000001, @01000010
	defb @00000000, @10000001
	defb @00000000, @10000001
	defb @00000000, @10000001
	defb @00000000, @10000001
	defb @10000001, @01000010
	defb @11000011, @00111100

	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
```

Our mask and graphic data are at the *circle_masked* label, mask byte first, and
as [discussed](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#pixel-positioning)
in the first article of this series, the padding bytes before and
after the actual graphic are required to assist SP1 with its pixel
positioning. The padding bytes require mask and graphic data pairs just like the
actual sprite data.

Save this listing to a file called *circle_sprite_masked.asm*.

## Drawing the masked sprite

Here's the code to draw the sprite. Save it to a file called 'circle_masked.c':

```
#pragma output REGISTER_SP = 0xD000

#include <arch/zx.h>
#include <arch/zx/sp1.h>
#include <intrinsic.h>
#include <z80.h>
#include <im2.h>
#include <string.h>

IM2_DEFINE_ISR(isr) {}
#define TABLE_HIGH_BYTE        ((unsigned int)0xD0)
#define JUMP_POINT_HIGH_BYTE   ((unsigned int)0xD1)

#define UI_256                 ((unsigned int)256)
#define TABLE_ADDR             ((void*)(TABLE_HIGH_BYTE*UI_256))
#define JUMP_POINT             ((unsigned char*)( (unsigned int)(JUMP_POINT_HIGH_BYTE*UI_256) + JUMP_POINT_HIGH_BYTE ))

extern unsigned char circle_masked[];

struct sp1_Rect full_screen = {0, 0, 32, 24};

int main()
{
  struct sp1_ss  *circle_sprite;
  unsigned char x;

  memset( TABLE_ADDR, JUMP_POINT_HIGH_BYTE, 257 );
  z80_bpoke( JUMP_POINT,   195 );
  z80_wpoke( JUMP_POINT+1, (unsigned int)isr );
  im2_init( TABLE_ADDR );
  intrinsic_ei();

  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  'X' );
  sp1_Invalidate(&full_screen);
 
  circle_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 2, (int)circle_masked, 0);

  sp1_AddColSpr(circle_sprite, SP1_DRAW_MASK2RB, SP1_TYPE_2BYTE, 0, 0);

  x=0;
  while(1) {
    sp1_MoveSprPix(circle_sprite, &full_screen, 0, x++, 4);
    intrinsic_halt();
    sp1_UpdateNow();
  }
}
```

The compile line is:

```
zcc +zx -vn -m -startup=31 -clib=sdcc_iy circle_masked.c circle_sprite_masked.asm -o circle_masked -create-app
```

Running the program sees the screen fill with 'X's and our little circle sprite
glides across the screen, left to right, floating above the background, neatly
blended into it via the mask.

### SP1 and the interrupt

This code uses the Spectrum's hardware interrupt: it calls *intrinsic_ei()* to
enable the interrupt (Z88DK programs start with interrupts disabled), and uses
*intrinsic_halt()* to pause and wait for the interrupt between each screen
update. As has been
[discussed](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#runtime),
you don't need to *HALT* the Z80 in SP1 programs in order to avoid flickering,
so you might wonder what's going on here. If you take out the *intrinsic_halt()*
call you'll see: the sprite zips across the screen too quickly to
observe. Waiting on the interrupt locks the update to moving the sprite one
pixel every interrupt. Since the Spectrum generates 50 interrupts a second, the
*intrinsic_halt()* makes the updates slow down and the sprite moves at 50 pixels
a second. The Spectrum's screen is 256 pixels wide, so at 50 frames per second
(fps) it takes the sprite about 5 seconds to cross the screen.

In order to use the 50Hz interrupt with SP1 we need to stop it calling the
Spectrum ROM's default interrupt routine, which is incompatible with SP1. (The
ROM routine assumes exclusive use of some registers which the SP1 library uses.)
Disabling interrupts is one simple answer to the problem, but since it's fairly
typical for SP1 programs to use the ISR to do other background tasks like maintain
timers or play music, installing a custom ISR is a more common practice. In this
simple example our interrupt service routine, *isr()*, is empty. It still gets
called, and we can still *HALT* the Z80, the ISR just doesn't do anything.

The default SP1 installation leaves room for the interrupt vector table at
0xD000, and the jump vector at 0xD1D1. All these details are covered in the
[interrupts](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_08_Interrupts.md)
document of this getting started guide.

### Masked sprite modifications

Other than the interrupt and the tweak to *sp1_Initialize()* which populates
the background tiles, there are only two other significant differences between
this code and the version of it introduced in the first article in this
series. Firstly, the *sp1_CreateSpr()* and *sp1_AddColSpr()* calls specify draw
functions called *SP1_DRAW_MASK2LB* and *SP1_DRAW_MASK2RB* respectively, and
have a sprite type of *SP1_TYPE_2BYTE*. This is because we're drawing a masked
sprite, with 2 bytes per scan line (one mask, one data). Secondly, we're moving
the sprite with a call to *sp1_MoveSprPix()* instead of *sp1_MoveSprAbs()*. The
*Pix* version of the move function takes pixel coordinates, which are frequently
easier to work with than the cell/rotation arguments the *Abs* sprite move
function takes. Both sprite moving functions do the same thing in the end, so
use whichever one works best with the positioning data your program has to hand.

## Multiple sprites

Since we've now introduced the concept of timings, let's have a look at how SP1
copes with multiple sprites.

Save this code to a file called 'circle_masked_multi.c':

```
#pragma output REGISTER_SP = 0xD000

#include <arch/zx.h>
#include <arch/zx/sp1.h>
#include <intrinsic.h>
#include <z80.h>
#include <im2.h>
#include <string.h>

IM2_DEFINE_ISR(isr) {}
#define TABLE_HIGH_BYTE        ((unsigned int)0xD0)
#define JUMP_POINT_HIGH_BYTE   ((unsigned int)0xD1)

#define UI_256                 ((unsigned int)256)
#define TABLE_ADDR             ((void*)(TABLE_HIGH_BYTE*UI_256))
#define JUMP_POINT             ((unsigned char*)( (unsigned int)(JUMP_POINT_HIGH_BYTE*UI_256) + JUMP_POINT_HIGH_BYTE ))


extern unsigned char circle_masked[];

struct sp1_Rect full_screen = {0, 0, 32, 24};

typedef struct
{
  struct sp1_ss  *sprite;
  unsigned char   x_pos;
  unsigned char   y_pos;
} CIRCLE_SPRITE;

#define NUM_SPRITES  3

CIRCLE_SPRITE circle_sprites[NUM_SPRITES];

int main()
{
  unsigned char i;

  memset( TABLE_ADDR, JUMP_POINT_HIGH_BYTE, 257 );
  z80_bpoke( JUMP_POINT,   195 );
  z80_wpoke( JUMP_POINT+1, (unsigned int)isr );
  im2_init( TABLE_ADDR );
  intrinsic_ei();

  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  'X' );
  sp1_Invalidate(&full_screen);
 
  for( i=0; i<NUM_SPRITES; i++ )
  {
    circle_sprites[i].sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 2, (int)circle_masked, 0);
    sp1_AddColSpr(circle_sprites[i].sprite, SP1_DRAW_MASK2RB, SP1_TYPE_2BYTE, 0, 0);

    circle_sprites[i].x_pos = i*10;
    circle_sprites[i].y_pos = i*10;
  }

  while(1)
  {
    for( i=0; i<NUM_SPRITES; i++ )
    {
      sp1_MoveSprPix(circle_sprites[i].sprite, &full_screen, 0, circle_sprites[i].x_pos++, circle_sprites[i].y_pos);
    }
    intrinsic_halt();
    sp1_UpdateNow();
  }
}
```

Since we're discussing timings and performance, we'll turn on the SDCC
compiler's options for full optimisation for this compile:

```
zcc +zx -vn -m -startup=31 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 circle_masked_multi.c circle_sprite_masked.asm -o circle_masked_multi -create-app
```

This example uses multiple sprites. Instead of a single *sp1_ss* pointer, we
define a structure to hold the necessary details of a sprite (*sp1_ss and screen
location), then create an array of those structures. For now the created sprites
all use the same sprite data (the masked circle sprite); they're intialised to
different screen x,y locations. Each time round the game loop all the sprites
are moved one pixel, left to right, as before.

## Exercises for the reader

There's enough here to play with, so we leave some exercises for the reader:

* Modify the sprite mask to open up the centre of the circle sprite.

* How many 8x8 pixel, masked sprites can SP1 draw in 1/50th of a second
(i.e. between the *HALT*s)?

* What happens if too many sprites are used, such that SP1 can't redraw them all
in 1/50th second?

* Take out the *intrinsic_halt()* call from the second example and rerun the
tests. Now what happens? Increase the number of sprites to see how many SP1
could realistically manipulate in a game.

* Replace the masked sprite data and code with the simple LOADed sprite and code
from the [first example](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#program-1---sp1-circle-sprite). The simpler drawing algorithm is faster, so how many
more sprites can it handle each frame? But what happens on screen?  
(Note: Perhaps a simpler way to change to LOAD sprites is to use the SP1_DRAW_LOAD2LB 
and SP1_DRAW_LOAD2RB draw functions in place of the MASK ones used.  These are still 
2-byte draw functions that simply ignore the mask byte when the sprite is drawn; the 
extra mask byte is wasted on this draw function but it does allow sprite graphics 
defined with masks to be used).

* Try changing the *circle_sprites[i].x_pos++* code which moves each sprite 1
pixel to *circle_sprites[i].x_pos+=2*, to move them 2 pixels. How does that
look? What about 3 pixels at a time?


* Can you mix different sprite types on screen?  Try creating some sprites as MASK, 
some as LOAD and some as OR.  Use the 2-byte draw functions for the LOAD and 
[OR sprites](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx/sp1.h#L177) 
so that all the sprites can share the MASK sprite graphics.


## Conclusion

Resources are limited on the Spectrum, so in order to make exciting games we
need to find tradeoffs. Games can run at 50fps, or 25fps, or maybe 12fps, and
still be playable. Sometimes it works to update the player's sprite at 50fps for
best responsiveness, and only update the other sprites every other time around
the game loop. Sometimes disposing of a background pattern in order to use a
faster sprite drawing algorithm works better. Sprites moving at 1 pixel per
frame look smooth, but even at 50fps they don't move very quickly. We can make
them zip about a lot quicker by moving them more pixels each time, but maybe at
the expense of jerky movement. SP1 puts all of these options in the hands of the
programmer.

### Where To Go From Here

More of the [example
links](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#where-to-go-from-here)
given in the first article in this series will now make sense, since most of them
use masked sprites.

The [next article](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_03_AnimatedSprite.md)
in this series explores sprite animation.