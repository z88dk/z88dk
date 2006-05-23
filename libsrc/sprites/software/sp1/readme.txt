
// SOFTWARE SPRITE ENGINE
// SP1 - Z88DK Sprite Package #1

Sprite Pack v3.0
(c) 2002-2006 aralbrec
z88dk license applies

// DOCUMENTATION

Docs and test programs will be located in the docs
and test directories respectively, as they are
written.  Yes, this note was required because
there is little there at the moment :)

// OVERVIEW

Briefly, Sprite Pack is a character-cell oriented
flicker-free sprite engine organized around a
differential-update drawing algorithm.  It does not
have to synchronize with the raster to achieve
flicker-free operation.  The bitmapped display is
divided into character cells (usually 8x8 pixels
though this varies with platform), each of which
can contain a single background tile and any number
of sprite characters.

Sprites can be any size measured in character cells
and can be moved in pixel increments, optionally
making use of a built-in software rotater.  Sprites
can be any of a variety of types (33 types in this
version!) that vary in how they mix with background
elements and how quickly they draw.

Only portions of the display that change, in units
of character cells, are drawn during screen updates.
Changes are accumulated and then drawn all at once
with a single call to sp1_UpdateNow().  This
accumulation guarantees that each redrawn character
cell is drawn exactly once, rather than multiple
times as may occur in more naive implementations
where multiple sprites move through the same
screen area.

The flicker-free feature of this engine and some
of the speed optimizations it implements means
a rather large data area is required by the
library.

The library is designed to be called from
C or asm or both.  The C API is, of couse,
documented in the header file.  Asm entry
points can typically be constructed from
the C name for a function with the leading
"sp1_" replaced with "SP1".  Eg the C
entry point "sp1_UpdateNow" has an equivalent
asm entry point "SP1UpdateNow".  The register
set-up to each asm function is described in
the *.asm files in the implementation
subdirectores.

This engine is best used in games with small
portions of the screen changing between updates.
Eg - platformers, 3d isometrics, strategy,
simulations and many types of non-scrolling
arcade games.

// COMPILING THE LIBRARY

Instructions below for the spectrum target, follow
the same procedure for another target.

1. Copy "spectrum-customize.asm" to "customize.asm"
2. Edit "customize.asm" to decide on display area
   and to place the various data structures the
   library requires at addresses in memory of
   your choosing.
3. Make the library by entering on the command-line:
   "make spectrum"

The header file "sp1.h" will be created in
{z88dk}/include/sprites and the customized
library file "sp1.lib" will be created in
{z88dk}/lib/clibs.

Write your program, remembering to include the
library header with "#include <sprites/sp1.h>"
and link the library during compilation by
adding "-lsp1" to the compile command.

Some more platform specific information can
be found in the "readme.txt" files in the
platform subdirectories.

- aralbrec 04.2006
