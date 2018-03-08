# ZX Spectrum Development with C, Z88DK and SP1 - Getting Started

This document describes how to get started writing ZX Spectrum programs using
C, Z88DK and the SP1 sprite library. 

## Purpose

<<<TODO, if at all? Introduction, maybe?>>>

## Assumptions

The reader is assumed to have read the Z88DK getting started guide, which covers
getting started with Z88DK and its 'C' programming environment. A complete
understanding of the details of the more advanced topics such as BiFrost and
interrupts is not required, but understanding how to view a Spectrum memory map
is. The reader is assumed to be familiar with at least the first 6 installments
of that guide.

<<<TODO Add link to the tutorial. It's not essential, but a skim read of the
ideas would be useful.>>>

## Strategy

SP1 is one of those technologies where you need to know quite a lot of
it in order to make sense of any of it. This can make it tricky to
learn, with the danger the user gets lost chasing down endless
dependency information and rapidly losing the plot.

We shall try to avoid this scenario by deliberately skimming, and in
many cases ignoring, fine details and nuances which a beginner
shouldn't be worrying about. We're going to dive straight into code,
and the reader will need to accept that not everything will be
explained as we go.

## Program 1 - SP1 Circle Sprite

We're going to start with a program which sets up the SP1
library, creates a small (8x8 pixel) sprite, and places it on screen in
the simplest way possible. There isn't going to be a mask, and the
sprite will be loaded straight into screen memory overwriting whatever
is there. We have to start somewhere.

And we start not with C code, but assembly language. Save this listing to a
file named 'circle.asm':

```
SECTION rodata_user

PUBLIC _circle

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000

._circle
	defb @00111100
	defb @01000010
	defb @10000001
	defb @10000001
	defb @10000001
	defb @10000001
	defb @01000010
	defb @00111100
```

This piece of assembly defines an SP1 sprite in 16 data bytes. We
could do this quite easily in C of course, given that it's only 16
static numbers, but we use assembly language for it because the
assembler allows numbers to be declared using binary notation, whereas
C doesn't. You can see the pattern of the sprite in the ones and
zeroes which makes it a little easier to look at.

The very top line of the file sets the *section* of the final program
this piece of data needs to go into. Z88DK uses sections to arrange
the final output in the Spectrum's memory. The
[details](https://www.z88dk.org/wiki/doku.php?id=temp:front#assembly_language)
aren't important at this stage, just be aware that if C code is to
use the data being specified in an assembly language file, that data
needs to be placed in the *read only user's data* section.

Next we declare the label *circle* to be publicly visible such that
code in external files (the C source) can see it.

Then we define 8 zero bytes. This isn't, as might be expected by more
experienced readers, anything to do with a mask. As stated, this
example isn't going to use a mask. There's another reason for placing
these 8 bytes here, and we'll come to it shortly.

Finally we see the 8x8 pixel sprite data, labelled as *_circle* with a
leading underscore, which is how the C compiler expects to be able to
reference it. These 8 bytes define a small circle in exactly the same
manner as a traditional user defined graphic (UDG).

We therefore have our sprite data, defined in assembly language. Let's
now look at some C code.

Save this listing to a file named 'circle.c':

```
#pragma output REGISTER_SP = 0xD000

#include <intrinsic.h>
#include <arch/zx.h>
#include <arch/zx/sp1.h>

extern unsigned char circle[];

int main()
{
  struct sp1_Rect full_screen = {0, 0, 32, 24};
  struct sp1_ss  *circle_sprite;

  intrinsic_ei();
  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  ' ' );
  sp1_Invalidate(&full_screen);
 
  circle_sprite = sp1_CreateSpr(SP1_DRAW_LOAD1LB, SP1_TYPE_1BYTE,  2,  0,  0);

  sp1_AddColSpr(circle_sprite, SP1_DRAW_LOAD1RB, 0, 0, 0);

  sp1_MoveSprAbs(circle_sprite, &full_screen, 0, 0, 0, 0, 0);

  intrinsic_halt();
  sp1_UpdateNow();

  while(1);
}
```

Compile this, together with the graphical data in the assembly
language file, using this line:

```
zcc +zx -vn -m -startup=31 -clib=sdcc_iy circle.c circle_sprite.asm -o circle -create-app
```

When you run the resultant program you'll see the border turns black
and the 8x8 pixel circle sprite appears in the top left corner of the
screen. It's not much, but it's a start.

#### The SP1 header file and library

As
[discussed](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md#header-files)
in installment 1 of the Z88DK getting started guide, the header files
for the sdcc compiler and the new libraries are found here:

```
include/_DEVELOPMENT/sdcc
```

so the *sp1.h* header file, which is included in this example code,
and which declares the SP1 library interface, is here:

```
include/_DEVELOPMENT/sdcc/arch/zx/sp1.h
```

You should keep this file open. It is currently sparsely documented,
but it's still the definitive guide to the SP1 C interface. Also, be
aware that SP1 is configured when Z88DK is installed and
built, and several files are automatically generated to match the
local configuration. Although we're not going to cover the SP1
reconfiguration here, it's for this reason you should always reference
your local copy of the header file, not the one online at GitHub.

The SP1 library code we're using is in the 'iy' version of the
standard C library, as described
[here](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md#library-files).
On Linux you can confirm this with a command such as:

```
>z80nm $ZCCCFG/../../libsrc/_DEVELOPMENT/lib/sdcc_iy/zx.lib | less
```

and search for 'sp1' in the output.


#### The C code

Returning to the example C code, we see a pragma at the top which
moves the stack pointer from its default location down to address
0xD000 (53248 decimal). We'll look at the memory map of an SP1 program
in due course; for now we just need to understand that the SP1
library (in its default configuration) builds its data structures in
high memory. This pragma moves the stack pointer below those data
structures.
<<<TODO Check -1 required?>>>

Recall that the data for the sprite was defined in the assembly
language file we're linking this C code to. We therefore declare our
circle sprite data as an external character array, which is how the C
compiler will see it.

In the *main()* code we see the function call which initialises the
SP1 library, *sp1_Initialize()*. The 3 flags in the first argument are
standard boilerplate for an SP1 program on the
Spectrum. Unfortunately, and as is frequently the case with SP1, the
documentation is lacking, but there's a forum post
[here](https://www.z88dk.org/forum/viewtopic.php?pid=15708#p15708)
which describes these flags in detail. It's not necessary to
understand them at this point. The next argument initialises the
screen to black ink on white paper, and the final argument specifies a
'tile' to prepare the screen with. We haven't covered tiles yet; at
this stage it can be seen as a character to fill the screen with. A
space effectively clears the screen.

We then 'invalidate' a rectange of screen space, defined in character
cells. This tells the screen updater algorithm in SP1 that the
specified area - in this case it's the whole of the Spectrum screen -
is going to need to be redrawn when we get to that point.

Next we have to create the sprite. SP1 sprites are initially created
as empty structures, then the graphical data is subsequently filled
in. The first call we see is therefore *sp1_CreateSpr()* which creates
the sprite structure. This is followed by a call to *sp1_AddColSpr()*
which adds in a single column of data to the sprite. A 'column' in
this context is an 8 pixel wide block of graphical data as tall as the
sprite. Since our sprite is only 8 pixels wide in total we only need a
single call to *sp1_AddColSpr()*. A 16 pixel wide sprite would need a
second call. There is a lot of detail in these 2 function calls which
we need to cover, so we'll return to them in a moment.

Next, we place the sprite ready to be drawn via the call to
*sp1_MoveSprAbs()*. The final 4 arguments to this function specify
exactly where to place the sprite in row, column, horizontal rotation,
vertical rotation, format. The row and column specify the character
cell location for the sprite in the ranges 0-32 and 0-23
respectively. The horizontal and vertical rotation values are both in
the range 0-7 and specify how many pixels to rotate the sprite data by
within the character cell so it sits in the exact pixel location
required.

The sprite's location in pixels is therefore:

```
 x = (row*8) + horizontal_rotation
 y = (col*8) + vertical_rotation
```

This method of screen positioning might seem a little fussy, but there
is good reason for it. As we shall see, SP1 largely works in character
cells, not pixels, and having the user's program specify values in
character cells where possible makes the library more efficient.

Up to this point the program has only been arranging things in
memory. Nothing has been drawn to the screen. To make that happen we
call *sp1_UpdateNow()* which is the function which causes the screen
to be updated. Although it's not necessary for this tiny example, it's
typical practice to use a call to *intrinsic_halt()* to wait for an
interrupt to occur before calling the screen updater function. This
causes the Z80 to stop work until the Spectrum's video circuitry
generates the next interrupt signal, at which point things
continue. Arranging the timing like this ensures the updater function
does all the video memory updates while the video circuitry is busy
drawing the top part of the Spectrum's border. As long as all the
video memory changes are complete before the video circuitry gets as
far as drawing the actual pixel display, everything will be flicker
free.

The program then drops into an infinite loop so we can see the result.

#### A closer look at the sprites code


### Pixel positioning

<<<TODO Explain those 8 zeroes above the sprite data>>>

### The memory map



[... continue to Part 2: Hello World](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_02_HelloWorld.md)
