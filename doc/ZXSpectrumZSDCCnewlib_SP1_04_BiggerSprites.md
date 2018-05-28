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
are of limited use for games. We need to look at how SP1 handles bigger sprites,
and sprites with colour.


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

