# ZX Spectrum Development with C, Z88DK and SP1 - Getting Started

This document describes how to get started writing ZX Spectrum programs using
C, Z88DK and the SP1 sprite library. 

## Purpose


## Assumptions

The reader is assumed to have read the Z88DK getting started guide, which covers
getting started with Z88DK and its 'C' programming environment. A complete
understanding of the details of the more advanced topics such as BiFrost and
interrupts is not required, but understanding how to view a Spectrum memory map
is. The reader is assumed to be familiar with at least the first 6 installments
of that guide.

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

Then we define 8 zero bytes. This isn't, as might be expected,
anything to do with a mask. As stated, this example isn't going to use
a mask. There's another reason for placing these bytes here, and we'll
come to it shortly.

Finally see the 8x8 pixel sprite data. 8 bytes which, in exactly the
same manner as a traditional user defined graphic (UDG), define a
small circle.

We therefore have our sprite data, defined in assembly language. Let's
now look at some C code.

Save this listing to a file named 'circle.c':

```
#pragma output REGISTER_SP = 53248

#include <arch/zx.h>
#include <arch/zx/sp1.h>

extern unsigned char circle[];

struct sp1_Rect full_screen = {0, 0, 32, 24};

struct sp1_ss  *circle_sprite;

int main()
{
  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  ' ' );
  sp1_Invalidate(&full_screen);
 
  circle_sprite = sp1_CreateSpr(SP1_DRAW_LOAD1LB, SP1_TYPE_1BYTE,  2,  0,  0);

  sp1_AddColSpr(circle_sprite, SP1_DRAW_LOAD1RB, 0, 0, 0);

  sp1_MoveSprAbs(circle_sprite, &full_screen, circle, 0, 0, 0, 0);
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

### The SP1 header file and library

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

As
[always](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md#library-files)
with these getting started guides, we're using sdcc and the new
libraries, so the SP1 library itelf is in the 'iy' version of the
standard C library. On Linux you can confirm this with a command such
as:

```
>z80nm $ZCCCFG/../../libsrc/_DEVELOPMENT/lib/sdcc_iy/zx.lib | less
```

and search for 'sp1' in the output.


#### Header Files


#### Library Files


[... continue to Part 2: Hello World](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md)
