# ZX Spectrum Development with C, Z88DK and SP1 - Bigger, Colourful Sprites

This document, the 4th in the SP1 part of the [ZX Spectrum Z88DK/C developer's
getting started
guide](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_GettingStartedGuide.md),
builds on the previous 3 installments, showing how to create bigger and more
colourful sprites. It follows on from the [third
document](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_03_AnimatedSprite.md)
which looked at anmiation.

## Purpose

So far in this SP1 series we've only looked at small, single character cell,
monochrome sprites. While simple to explore and understand, 8x8 pixel sprites
are of limited use for games. We need to look at how SP1 handles bigger sprites.
This is pretty straightforward stuff and we don't need to linger on it. A couple
of quick examples will suffice. While we're wrapping up our initial look at SP1
sprites we'll also have a look at applying some colour to them as well.

## 16x16 Pixel Sprite

The 16x16 pixel sprite is the mainstay of Spectrum graphics. It's big enough to
be nicely visible, but still small enough that the hardware can handle it.

As far as SP1 is concerned a 16x16 pixel sprite is made up of 2 columns, each 8
pixels wide and 16 pixels high. If aligned on 8 pixel boundaries the sprite will
occupy 4 character cells. If it's shifted horizontally by between 1 and 7 pixels
it'll occupy 2 more character cells in the horizontal plane, making a total of
6. If it's also shifted vertically by between 1 and 7 pixels it'll occupy 9
character cells, as shown in this image:

![alt text](images/16x16_numbered.png "16x16 sprite in 9 char cells")

All of this detail is handled by SP1. All we have to do is create the sprite
much like we have been doing, and add the extra column being sure to tell SP1
the correct maximum height of the sprite in character cells.

### 16x16 Example

We're going to work through an example with a 16x16 pixel masked sprite kindly
provided by Dean Belfield at [Break Into Program](http://www.breakintoprogram.co.uk/):

![alt text](images/sprite_mask_example.png "Sprite mask example")

We need to convert this graphical data and the mask into an SP1 sprite data
structure. Here it is in assembly language, which you should save to a file
called *bubble_masked_sprite.asm*:

```
SECTION rodata_user

PUBLIC _bubble_col1
PUBLIC _bubble_col2
	
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000

._bubble_col1
	defb @11111100, @00000000
	defb @11110000, @00000011
	defb @11100000, @00001100
	defb @11000000, @00010000
	defb @10000000, @00100110
	defb @10000000, @00101000
	defb @00000000, @01001000
	defb @00000000, @01000000
	defb @00000000, @01000000
	defb @00000000, @01000000
	defb @10000000, @00100000
	defb @10000000, @00100000
	defb @11000000, @00010000
	defb @11100000, @00001100
	defb @11110000, @00000011
	defb @11111100, @00000000

	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000

._bubble_col2
	defb @00111111, @00000000
	defb @00001111, @11000000
	defb @00000111, @00110000
	defb @00000011, @00001000
	defb @00000001, @00000100
	defb @00000001, @00000100
	defb @00000000, @00000010
	defb @00000000, @00000010
	defb @00000000, @00000010
	defb @00000000, @00000010
	defb @00000001, @00000100
	defb @00000001, @00000100
	defb @00000011, @00001000
	defb @00000111, @00110000
	defb @00001111, @11000000
	defb @00111111, @00000000
		
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
	defb @11111111, @00000000
```

Consider this carefully in relation to the graphic above: we have 2 columns of
8-pixel-wide data, labelled *bubble_col1* and *bubble_col2*. Each has 16 rows,
and each row consists of a mask byte followed by a data byte. This data layout
is the same as we saw in the earlier [masked sprite example](), only with twice
the vertical data (16 rows instead of 8). The first column is the left side of
the sprite (with mask), and the second column is the right side (with mask).

As usual with SP1, in order to allow vertical pixel positioning we add 7 empty
rows (with mask) before each column, and 7 empty rows (with mask) after each
column. Note how the middle block of empty rows serves as both the *after* rows
for the first column and the *before* rows for the second column.

To display this sprite we need to follow our now established pattern, using this
code to initialise the sprite structure:

```
bubble_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, (int)bubble_col1, 0);
sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)bubble_col2, 0);
sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2RB,  SP1_TYPE_2BYTE, 0, 0);
```

The first line creates the sprite as being 3 character cells high and
establishes its leftmost column from the data at *bubble_col1* . Then we add a
second column of data from the data at *bubble_col2*. The right boundary column
is then added, this one taking no data as it will be generated by SP1 should the
sprite be positioned such that the second column needs to be rotated into a
third.

Here's a program which glides the bubble sprite over a background of 'X's in the
manner we've seen previously:

```
#pragma output REGISTER_SP = 0xD000

#include <z80.h>
#include <arch/zx.h>
#include <arch/zx/sp1.h>

extern unsigned char bubble_col1[];
extern unsigned char bubble_col2[];

struct sp1_Rect full_screen = {0, 0, 32, 24};

int main()
{
  struct sp1_ss *bubble_sprite;
  unsigned char x;

  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  'X' );
  sp1_Invalidate(&full_screen);
 
  bubble_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, (int)bubble_col1, 0);
  sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)bubble_col2, 0);
  sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2RB,  SP1_TYPE_2BYTE, 0, 0);

  x=0;
  while(1)
  {
    sp1_MoveSprPix(bubble_sprite, &full_screen, 0, x++, 80);

    z80_delay_ms(25);
    sp1_UpdateNow();    
  }
}
```

Save this to *bubble_masked.c* and compile it with:

```
zcc +zx -vn -m -startup=31 -clib=sdcc_iy bubble_masked.c bubble_masked_sprite.asm -o bubble_masked -create-app
```

If you prefer the alternative method of specifying sprite data, as we saw in the
[previous article](), you can specify the the sprite initialisation like this:

```
bubble_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 0, 0);
sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, bubble_col2-bubble_col1, 0);
sp1_AddColSpr(bubble_sprite, SP1_DRAW_MASK2RB,  SP1_TYPE_2BYTE, 0, 0);
```

This creates the sprite with null data and uses an address calculation in the
compiler to calculate the offset to the second column. You then place the sprite
with:

```
sp1_MoveSprPix(bubble_sprite, &full_screen, bubble_col1, x, y);
```

As previously discussed, you provide the graphical data address in the sprite
move function call, and SP1 finds the rest of the column data using the offsets
which were provided in the column addition calls. The effect is the same as with
the listing above, just achieved slightly differently.

### A Bigger Example

Here's an example of a bigger *mothership* type of sprite, seen in [ZX
Paintbrush]() as graphic and mask:

![alt text](images/mothership.png "mothership sprite")

Unfortunately ZX Paintbrush doesn't export to an ASM listing format which SP1
can use directly, but it can get close enough to make it practical to cut and
paste its output into a suitable file. Here's a sample of its ASM output:

```
; ASM data file from a ZX-Paintbrush picture with 48 x 24 pixels (= 6 x 3 characters)

; line based output of pixel data:

defb @00000000, @00000000, @00011000, @00011000, @00000000, @00000000
defb @00000000, @00000000, @00100100, @00100100, @00000000, @00000000
defb @00000000, @00000000, @00100100, @00100100, @00000000, @00000000
defb @00000000, @00000000, @00011000, @00011000, @00000000, @00000000
defb @00000000, @00000000, @00000110, @01100000, @00000000, @00000000
defb @00000000, @00000000, @00000001, @10000000, @00000000, @00000000
defb @00000000, @00000000, @00000001, @10000000, @00000000, @00000000
defb @00000000, @00000000, @00000100, @00100000, @00000000, @00000000
defb @00000000, @00000000, @00000011, @11000000, @00000000, @00000000
defb @00000000, @00000000, @00000100, @00100000, @00000000, @00000000
defb @00000000, @00000111, @10001000, @00010001, @11100000, @00000000
defb @00000000, @00111000, @01110000, @00001110, @00011100, @00000000
defb @00000000, @11000000, @00000110, @01100000, @00000011, @00000000
defb @00000001, @00011100, @01110000, @00001110, @00111000, @10000000
defb @00000010, @01110001, @10000000, @00000001, @10001110, @01000000
defb @00011100, @00000000, @00001000, @00010000, @00000000, @00111000
defb @01110010, @01001110, @00110000, @00001100, @01110010, @01001110
defb @00001101, @10110001, @10000000, @00000001, @10001101, @10110000
defb @00000001, @00000000, @01010011, @11001010, @00000000, @10000000
defb @00000010, @00000000, @00101100, @00110100, @00000000, @01000000
defb @00011100, @00000000, @01000000, @00000010, @00000000, @00111000
defb @00110000, @00000001, @10000000, @00000001, @10000000, @00001100
defb @00000000, @00000000, @00000000, @00000000, @00000000, @00000000
defb @00000000, @00000000, @00000000, @00000000, @00000000, @00000000
```

The exported mask data looks similar.

A few minutes with a text editor which can handle columns, and this 48x24 pixel
graphic with mask looks like this, which you can save to a file called
*mothership_sprite.asm*:

```
SECTION rodata_user

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col1
._mothership_col1

 defb @11111111, @00000000
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111110, @00000001 
 defb @11111100, @00000010 
 defb @11100000, @00011100 
 defb @10000000, @01110010 
 defb @11110000, @00001101 
 defb @11111110, @00000001 
 defb @11111101, @00000010 
 defb @11100011, @00011100 
 defb @11001111, @00110000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col2
._mothership_col2

 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111000, @00000111 
 defb @11000000, @00111000 
 defb @00000000, @11000000 
 defb @00000000, @00011100 
 defb @00000000, @01110001 
 defb @00000000, @00000000 
 defb @00000000, @01001110 
 defb @00000000, @10110001 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111110, @00000001 
 defb @11111111, @00000000 
 defb @11111111, @00000000 

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col3
._mothership_col3

 defb @11100111, @00011000 
 defb @11000011, @00100100 
 defb @11000011, @00100100 
 defb @11100111, @00011000 
 defb @11111001, @00000110 
 defb @11111110, @00000001 
 defb @11111110, @00000001 
 defb @11111000, @00000100 
 defb @11111100, @00000011 
 defb @11111000, @00000100 
 defb @01110000, @10001000 
 defb @00000000, @01110000 
 defb @00000000, @00000110 
 defb @00000000, @01110000 
 defb @00000000, @10000000 
 defb @00000000, @00001000 
 defb @00000000, @00110000 
 defb @00000000, @10000000 
 defb @10000000, @01010011 
 defb @11010011, @00101100 
 defb @10111111, @01000000 
 defb @01111111, @10000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col4
._mothership_col4

 defb @11100111, @00011000 
 defb @11000011, @00100100 
 defb @11000011, @00100100 
 defb @11100111, @00011000 
 defb @10011111, @01100000 
 defb @01111111, @10000000 
 defb @01111111, @10000000 
 defb @00011111, @00100000 
 defb @00111111, @11000000 
 defb @00011111, @00100000 
 defb @00001110, @00010001 
 defb @00000000, @00001110 
 defb @00000000, @01100000 
 defb @00000000, @00001110 
 defb @00000000, @00000001 
 defb @00000000, @00010000 
 defb @00000000, @00001100 
 defb @00000000, @00000001 
 defb @00000001, @11001010 
 defb @11001011, @00110100 
 defb @11111101, @00000010 
 defb @11111110, @00000001 
 defb @11111111, @00000000 
 defb @11111111, @00000000 

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col5
._mothership_col5

 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @00011111, @11100000 
 defb @00000011, @00011100 
 defb @00000000, @00000011 
 defb @00000000, @00111000 
 defb @00000000, @10001110 
 defb @00000000, @00000000 
 defb @00000000, @01110010 
 defb @00000000, @10001101 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 
 defb @01111111, @10000000 
 defb @11111111, @00000000 
 defb @11111111, @00000000 

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000

PUBLIC _mothership_col6
._mothership_col6

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @01111111, @10000000
 defb @00111111, @01000000
 defb @00000111, @00111000
 defb @00000001, @01001110
 defb @00001111, @10110000
 defb @01111111, @10000000
 defb @10111111, @01000000
 defb @11000111, @00111000
 defb @11110011, @00001100
 defb @11111111, @00000000 
 defb @11111111, @00000000

 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
 defb @11111111, @00000000
```

This should appear familiar by now: we have 6 columns (i.e. 6*8=48 pixels) of 24
rows, each row consisting of 2 bytes, mask and graphic. Each column is separated
by 7 rows of null data to allow precise positioning.

Here's the *mothership_masked.c* listing which shows the sprite:

```
#pragma output REGISTER_SP = 0xD000

#include <z80.h>
#include <arch/zx.h>
#include <arch/zx/sp1.h>

extern unsigned char mothership_col1[];
extern unsigned char mothership_col2[];
extern unsigned char mothership_col3[];
extern unsigned char mothership_col4[];
extern unsigned char mothership_col5[];
extern unsigned char mothership_col6[];

struct sp1_Rect full_screen = {0, 0, 32, 24};

int main()
{
  struct sp1_ss  *mothership_sprite;
  unsigned char x;

  zx_border(INK_BLACK);

  sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                  INK_BLACK | PAPER_WHITE,
                  'X' );
  sp1_Invalidate(&full_screen);
 
  mothership_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 4, (int)mothership_col1, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col2, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col3, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col4, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col5, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col6, 0);
  sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2RB,  SP1_TYPE_2BYTE, 0, 0);

  x=0;
  while(1)
  {
    sp1_MoveSprPix(mothership_sprite, &full_screen, 0, x++, 0);

    z80_delay_ms(10);
    sp1_UpdateNow();    
  }
}
```

Note that this 24 pixel high sprite needs to be created as 4 character cells high.

Compile with:

```
zcc +zx -vn -m -startup=31 -clib=sdcc_iy mothership_masked.c mothership_sprite.asm -o mothership_masked -create-app
```

The alternative way of building the sprite looks like this:

```
mothership_sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 4, 0, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col2-mothership_col1, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col3-mothership_col1, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col4-mothership_col1, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col5-mothership_col1, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2,    SP1_TYPE_2BYTE, (int)mothership_col6-mothership_col1, 0);
sp1_AddColSpr(mothership_sprite, SP1_DRAW_MASK2RB,  SP1_TYPE_2BYTE, 0, 0);
```

and you'd position the sprite with:

```
sp1_MoveSprPix(mothership_sprite, &full_screen, mothership_col1, x, y);
```



## Adding Colour

SP1 treats sprite colour quite separately from the pixels of the graphical
data. Because colour on the Spectrum is limited by the hardware a lot of games
are presented with monochrome graphics. SP1 is fine with this: if you don't need
colour, the library doesn't slow things down by forcing you to use it.

Colour on the Spectrum, as we all know, is controlled at the character cell
level. Each 8x8 pixel block has an ink colour, a paper colour, and flash and
inverse attributes. When a sprite is placed on screen it will fill, or partially
fill, one or more of these attribute cells. These cells are known in SP1 as
*background tiles*, and we met them briefly in [article 3]() of this series.

In order to place a sprite in pixel-perfect position, SP1 pre-prepares (at
sprite creation time) a number of *character cell structures*, known as *char
struct*s. You can see the definition of this structure in the [SP1 header
file](), although for the purposes of this discussion you can treat it as
opaque. An 8x8 pixel sprite will require 4 of these, since it can occupy a
maximum of 4 character cells on screen . For a 16x16 pixel sprite, 9 such char
structs will be pre-prepared. And so on - since SP1 can support sprites of
arbitrary size, the number of char structs required is also arbitrary. These
char structs describe, amongst other things, the colour attributes the
background tiles need to take when the sprite occupies them, and hence it's a
sprite's char structs which must be modified to add colour to a sprite.

Because a sprite can be of arbitrary size, and can hence have an arbitrary
number of char structs controlling it, SP1 needs a way to allow these char
structs to be updated. This is done by an iterator function,
*sp1_IterateSprChar()*, which is called with a sprite structure and a pointer to
a C function. This iterator function iterates each char struct of the sprite
calling the given function for each one. So for an 8x8 pixel sprite the iterator
will call the given function 4 times, for a 16x16 pixel sprite the iterator will
call the given function 9 times, etc. On each call of the given function, one of
the sprite's char structs will be passed as a parameter, so it's in this
function that the user's code can update the sprite's colour attributes for one
part of the sprite.




It's important to remember that the
number of attribute cells a sprite can effect can change each time the sprite
the moved. If an 8x8 pixel sprite is positioned on an 8 pixel boundary in both
the horizonal and vertical directions it'll occupy a single attribute cell. It
if moves a single pixel down it'll suddenly occupy 2 attribute cells, and if it
then goes across a pixel it'll be occupying 4 attribute cells.

## Exercises for the reader


## Conclusion

