# ZX Spectrum Development with Z88DK - Simple Graphics

This is the third document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compliant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is covered.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 2](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md).
If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Simple Graphics

This guide examines the Z88DK capabilities for handling low level graphics
primitives like drawing lines and plotting points. But prepare for a
disappointment.

There's a header file full of graphics routines here:

```
 include/graphics.h
```

[This](https://github.com/z88dk/z88dk/blob/master/include/graphics.h) is what
we're after: draw, plot, circle, all sorts of stuff. But there's a problem. The
header file is in the Z88DK include/ directory, whereas the header files for the
new library is, as we've seen in the previous installments of this
series, [here](https://github.com/z88dk/z88dk/tree/master/include/_DEVELOPMENT/sdcc):

```
 include/_DEVELOPMENT/sdcc/
```

The explanation is that the header files in the include/ directory relate to
functions in the _classic_ library. We're using the newer compiler with the _new_
library, and you'll notice that there's no graphics.h file in the
include/_DEVELOPMENT/sdcc directory. As of this writing, June 2017, the graphics
routines haven't yet been ported to the new library.

Thus, for now at least, we meet a dead end. If your application requires the
graphics libraries, or any other routines which aren't yet in the new library,
your only option is to switch to using the classic library. Although still well
supported by Z88DK, and therefore a practical option, this is outside the scope
of this guide which concerns itself exclusively with the new library.

This is an important lesson. There are two compilers in Z88DK, two sets of
libraries and two sets of headers. You need to pay attention to which you're
using, which headers you're examining, and which are being referred to in the
documentation, emails and forum posts you're reading. The graphics routines are
a relatively simple case because they appear in one but are nowhere to be seen
in the other; it gets more confusing when some classic library code has been
ported to the new library, and has been updated on the way. If you find
yourself reading the documentation for the older code, while compiling and
linking in the new code, you're going to get confused. While the Z88DK library
transition is ongoing, you need to pay attention.

## All Is Not Lost

The new library doesn't contain the graphics routines we want, but all is not
lost if you're prepared to get your programming hands a bit dirty. What follows
might be a little beyond the scope of a getting started guide, but it
demonstrates that Z88DK provides what is needed if you'd like a do-it-yourself
option.

### The Display File Address Manipulators

Although the new library does not contain graphics commands like line, circle,
and so on, it does contain some lower level functions that can help to implement
these sorts of commands.  So before leaving this installment, let's have a look at
how they might be used to implement plot and draw.

The Spectrum's display is memory mapped, which means a block of memory is set
aside to represent the screen contents. This area of memory is directly used to
generate the display. The range of memory addresses from 16384 to 22527
represent the pixels on screen. Each bit represents whether a particular pixel
is on or off. The range of addresses from 22528 to 23295 represent the colour
applied to each 8x8 group of pixels on screen. Z88DK calls the memory region
that represents pixels the "screen addresses" and the memory region that
represents colours the "attribute addresses."

The problem of drawing or printing into the display directly is really a problem
of working out which bit of which byte in the display memory contains the
pixel you want to set. Z88DK provides some manipulator functions that do this
for you.

The display address manipulator functions are defined in
[arch/zx.h](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx.h).

```
include/_DEVELOPMENT/sdcc/arch/zx.h
```

Note that this file is in the new library's include path, so it's ready to be
used with the new libraries.

If you scroll down you will find a block of functions under the "display"
heading. These are the functions that manipulate display addresses.

To make it clear what each function does, there is a naming convention applied to
each function name. In general function names are composed of strings like these:

```
saddr = screen address
aaddr = attribute address

px    = pixel x coordinate (0..255)
py    = pixel y coordinate (0..191)
pxy   = pixel (x,y) coordinate

cx    = character x coordinate (0..31)
cy    = character y coordinate (0..23)
cxy   = character (x,y) coordinate
```

If you wanted to find a function that converts a pixel x,y coordinate to a
screen address, you would look for something like `zx_pxy2saddr`. Because the
Spectrum stores the state of eight pixels in each byte, the screen address
returned by that function holds the state of eight pixels. To plot an
individual point, you would write a byte there that sets exactly one bit
corresponding to the individual pixel you want to plot. There is another function
zx_px2bitmask() that will tell you what byte to write given an x coordinate
and we will see how that is used in the example below.

It should be noted that both the character coordinates and the pixel coordinates
have (0,0) located at the top left of the screen.  BASIC does the same for
character coordinates but it places the pixel coordinate origin two character
lines above the lower left of the screen.  So the pixel coordinate system is a
little bit different in C.

### Plotting Points on Screen

To illustrate how these display manipulators can be used, let's write a program
that plots points at random on the screen.  Save this to a file called plot.c:

```
  /* C source start */

  #include <arch/zx.h>
  #include <stdlib.h>

  void plot(unsigned char x, unsigned char y)
  {
     *zx_pxy2saddr(x,y) |= zx_px2bitmask(x);
  }

  int main(void)
  {
     unsigned char i;

     zx_cls(PAPER_WHITE);
   
     for( i=0; i<15; i++ )
     {
        plot(rand()%256, rand()%192);      
     }
     return 0;
  }

  /* C source end */
```

Our compile line will use startup=31 because we have no use for stdio in this example:

```
 zcc +zx -vn -startup=31 -clib=sdcc_iy plot.c -o plot -create-app
```

In the plot() function, zx_pxy2saddr(x,y) returns a char* that represents the
screen address that contains the pixel to be plotted. To find out which bit in
the byte should be set, a call to zx_px2bitmask(x) is made. The result of that
call is a byte with a single bit set in it - that's the bit we want to set. Then
this byte is mixed into the display by ORing it in using the C operator "|=".

Notice we haven't done anything with colour. We're simply plotting pixels here and the
colour they will appear in depends on the current attribute value on screen which
is being set by `zx_cls()`.

### Drawing Lines on Screen

Let's go one step further and draw lines on screen. We'll do that the easy way by borrowing
some C code from the [internet](https://rosettacode.org/wiki/Bitmap/Bresenham%27s_line_algorithm#C)
that draws lines using the Bresenham algorithm. The results here will be quick but it's
not going to be the fastest possible way to draw lines.

It really isn't important to understand the Bresenham algorithm. The important
point here is that Z88DK provides the low level tools which enable such a
algorithm to be implemented.

Retaining our plot function and borrowing the internet line code, save the following in
file line.c:


```
  /* C source start */

  #include <arch/zx.h>
  #include <input.h>
  #include <stdlib.h>

  void plot(unsigned char x, unsigned char y)
  {
     *zx_pxy2saddr(x,y) |= zx_px2bitmask(x);
  }

  void line(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1)
  {
     unsigned char dx  = abs(x1-x0);
     unsigned char dy  = abs(y1-y0);
     signed   char sx  = x0<x1 ? 1 : -1;
     signed   char sy  = y0<y1 ? 1 : -1;
     int           err = (dx>dy ? dx : -dy)/2;
     int           e2;

     while (1)
     {
        plot(x0,y0);
        if (x0==x1 && y0==y1) break;
      
        e2 = err;
        if (e2 >-dx) { err -= dy; x0 += sx; }
        if (e2 < dy) { err += dx; y0 += sy; }
     }
  }

  int main(void)
  {
    unsigned char i;

    zx_cls(PAPER_WHITE);
   
    for( i=0; i<15; i++ )
    {
      line(rand()%256, rand()%192, rand()%256, rand()%192);
    }
    return 0;
  }

  /* C source end */
```

The compile line is the same as for the last example:

```
 zcc +zx -vn -startup=31 -clib=sdcc_iy line.c -o line -create-app
```

### Where To Go From Here

We didn't do anything with colour.  The function `zx_saddr2aaddr()` may be useful
for turning a screen address into a corresponding attribute address which you
could then use to write an attribute value.

Another simple modification may be to have the line routine draw a patterned line
instead of a solid black one.

Besides the screen address manipulators, there is one high level graphics function
in [arch/zx.h](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx.h#L280)
and that is `zx_pattern_fill()`.  This can be used to fill an area on screen with a pattern.

[... continue to Part 4: Input Devices](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_04_InputDevices.md)
