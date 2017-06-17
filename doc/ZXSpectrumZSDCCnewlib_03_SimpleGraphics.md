# ZX Spectrum Development with Z88DK - Simple Graphics

This is the third document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the older
sccz80 compiler nor the older "classic" libraries are covered.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from
[installment 2](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md).

## Simple Graphics

This guide examines the Z88DK capabilities for handling low level graphics
primitives like drawing lines and plotting points. But prepare for a
disappointment.

There's a header file full of graphics routines here:

```
 [include/graphics.h](https://github.com/z88dk/z88dk/blob/master/include/graphics.h)
```

This what we're after: draw, plot, circle, all sorts of stuff. But there's a
problem. The header file is in the Z88DK include/ directory, whereas the header
files for all the new libraries are, as we've seen in the previous installments
of this series, here:

```
 include/_DEVELOPMENT/sdcc/
```

The explanation is that the header files in the include/ directory relate to
functions in the classic librares. We're using the newer compiler with the new
libraries, and you'll notice that there's no graphics.h file in the
include/_DEVELOPMENT/sdcc directory. As of this writing, June 2017, the graphics
routines haven't yet been ported to the new library.

Thus, for now at least, we meet a dead end. If your application requires the
graphics libraries, or any other routines which aren't yet in the new libraries,
your only option is to switch to the older, sccz80 compiler with the classic
libraries. Although still well supported by Z88DK, and therefore a practical
option if needed, this is not the way forward, and not covered by this guide.

This is an important lesson. There are two compilers in Z88DK, two sets of
libraries and two sets of headers. You need to pay attention to which you're
using, which headers you're examining, and which are being referred to in the
documentation, emails and forum posts you're reading. The graphics routines are
a relatively simple case because they appear in one but are nowhere to be seen
in the other; it gets more confusing when some classic library code has been
ported to the new libraries, and has been updated on the way. If you find
yourself reading the documentation for the older code, while compiling and
linking in the new code, you're going to get confused. While the Z88DK library
transition is ongoing, you need to pay attention.
