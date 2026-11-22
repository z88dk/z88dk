# Hello World

This simple program demonstrates the use of a text terminal.

## Compiling

Compile with zsdcc (the high optimization setting can lead to long compile times):
~~~
zcc +sms -vn -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 hello.c -o hello -pragma-include:zpragma.inc -create-app
~~~
Compile with sccz80:
~~~
zcc +sms -vn -startup=1 -clib=new -O3 hello.c -o hello -pragma-include:zpragma.inc -create-app
~~~

## Compiling Details

Z88DK can compile a program using a selection of CRTs provided by the library.  The particular one a compile uses is specified by the "-startup" parameter.  Here is a list of what is available for the sms target at the time of writing:
~~~
-startup=0 (the default)
Plain CRT with a standard set of pragmas that customize the page zero code.

-startup=1
A CRT with one text terminal instantiated on stdout and stderr.  The text terminal does not understand control codes embedded in the ascii stream but it has many features that can be set via compile time pragmas or runtime ioctl() calls.

-startup=2
As startup=1 but the text terminal also understands a number of control codes that can be embedded in the ascii stream.

-startup=16
A plain devkitSMS CRT.  This is similar to startup=0 except a few restart locations are occupied by devkitSMS restart code and the devkitSMS interrupt routines are installed by default.

-startup=17
A devkitSMS CRT combined with the terminal from startup=1 (16+1=17).

-startup=18
A devkitSMS CRT combined with the terminal from startup=2 (16+2=18).
~~~
This program will use startup=1.

Many compile time options can be set via pragmas.  These pragmas can be present in .c source files or on the compile line but it's most convenient to place them all in a single file; here they are in file "zpragma.inc".

This file contains pragmas that show how to set optional SMS and SDSC header information and a few other things:

`#pragma printf = "c s d u lx lld"`

This pragma tells the library what printf converters should be enabled.  Without specifying this, the compiler will link a rather large set of converters that excludes floating point.  Being able to specify which are actually needed can reduce program size.
~~~
#pragma output CRT_OTERM_CHAR_PATTERN_OFFSET = -32
#pragma output CRT_OTERM_BACKGROUND_CHAR     = 0

#pragma output CRT_OTERM_WINDOW_X      = 4
#pragma output CRT_OTERM_WINDOW_WIDTH  = 24
#pragma output CRT_OTERM_WINDOW_Y      = 4
#pragma output CRT_OTERM_WINDOW_HEIGHT = 16
~~~
The latter four dimension the output terminal's initial position and size.

`CRT_OTERM_BACKGROUND_CHAR` records the terminal's erase tile.  This tile is absolute and ranges from 0-511.

`CRT_OTERM_CHAR_PATTERN_OFFSET` gives the character offset the terminal should add to ascii characters before printing them.  In this program the font is loaded to vram at tile position 0.  The font starts with a space, ascii 32, so by setting this pragma to -32, a space will be printed using tile 32-32 = 0.  Likewise an 'A' will be printed using tile 'A'-32.  All the terminal properties can be changed at runtime but this one in particular is useful since it allows changing of fonts.

The source code itself should be self-explanatory given the function names are verbose.  Keep in mind areas on screen are defined by a rectangle structure that defines x,width,y,height.

The 8x8 font comes out of Z88DK's library.  Most systems define 8x8 fonts as 1-bit, with each character defined in eight bytes.  Each bit indicates whether a pixel is set or not.  The SMS's tile definitions include colour information so that each 8x8 tile is instead 32 bytes in size.

In order to allow the SMS to use the standard 1-bit 8x8 fonts, the function `sms_copy_font_8x8_to_vram()` is supplied that will copy a 1-bit 8x8 font into vram and add extra colour information as it does so.  The first parameter is the font's address in memory, the second is how many characters to copy into vram and the last two are colours (0-15) for the background and foreground pixels respectively.
