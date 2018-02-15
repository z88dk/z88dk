# ZX Spectrum Development with Z88DK - Interrupts

This is the eighth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

This document relates specifically to the 48K Spectrum. Other models have more
complex memory management and are not covered here.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 7](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_07_BiFrost.md).

If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

Two documents are referenced in the introduction below: the generic interrupts
document in the Z88DK wiki, and the Coders Bucket blog post which covers
Spectrum interrupts more specifically. The reader is assumed to have read and
understood these documents. Concepts covered in them, such as the "vector
table," will not be described again here.

## Z88DK and the Spectrum's Interrupt Mode 2

Z88DK's support for Z80 interrupt handling is comprehensive and is already
described in detail in this [generic Z80 interrupts
document](https://www.z88dk.org/wiki/doku.php?id=library:interrupts) in the
Z88DK wiki. If the reader hasn't read that document, now is the time to do
so. The Spectrum's use of the Z80 interrupt is described rather well in this
[blog post](http://codersbucket.blogspot.co.uk/2015/04/interrupts-on-zx-spectrum-what-are.html),
albeit from a machine code perspective. This guide will build on those.

The Spectrum normally (i.e. when it's running BASIC) runs with the Z80 CPU in
interrupt mode 1. Mode 2 is the more flexible and powerful one, so we're going
to take a look at using interrupt mode 2 ("IM 2") on the 48K Spectrum from C
using Z88DK.

There are two key details which the reader needs to understand having read the
generic Z80 wiki document. The first is the use of the term "interrupting
peripheral" in the context of IM 2 on the ZX Spectrum. On the Spectrum, the
interrupting peripheral is the video circuitry. The Spectrum constantly
generates the interrupt signal in sync with the TV picture it's generating, and
it does so 50 times a second. This 50Hz signal is the Spectrum's interrupt, and
it's this which we'll be using from Z88DK.

The second key detail the reader needs to understand is concept of the
[interrupt mode 2](https://www.z88dk.org/wiki/doku.php?id=library:interrupts#im_2) "identifier
byte supplied by the interrupting peripheral". On the Spectrum the interrupting
peripheral, the video hardware, doesn't supply this indentifier byte. It
essentially arrives as a random number from 0-255, and this is the reason Spectrum
programs need to build a specifically configured vector table when using
interrupt mode 2. This is hinted at in the [second
example](https://www.z88dk.org/wiki/doku.php?id=library:interrupts#code_example_2)
in the wiki document which refers to "some im2-unaware devices" which don't
provide an identifier byte. That's referring to the Spectrum, amongst
others. We'll see how to handle this from C using Z88DK.

### A Non-simple Example

Unusually for this series, the example which follows isn't a particularly simple
one. The Z88DK wiki document already referenced provides a simple example to get
started with. What follows is a careful examination of how a IM 2 example can be
fitted into the Spectrum's memory model. If we're going to write complex
programs which use interrupts we need to think things through carefully. Just
throwing things into RAM as any location might work in the short term, but in
the longer term will result in baffling crashes when memory gets
corrupted. Let's take this slowly.

The steps required to set up a Spectrum IM 2 routine are these:

* fill in the vector table with a complete set of vectors, all the same
* at that vector, place an instruction to jump to the interrupt service routine
* set the Z80's I register to point at a vector table
* enable the interrupts

The first issue we need to cover is, where can we put the vector table and jump
instruction? The answer is, anywhere convenient. What follows is a description
of one solution which would work for a program where such things can be placed
out of the way in high memory. As befits a getting started guide, this
configuration will suit many scenarios and will suffice until the reader is
knowledgeable enough to work out a more suitable alternative for their situation. 

Our vector table needs to be 257 bytes. Referring back to (installment
6)[https://github.com/derekfountain/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_06_SomeDetails.md]
of this getting started guide where we looked at the memory map of the Spectrum,
we see that with the default compiler settings our simple program's memory map
looks like this:


```
+-------------+
|0xFFFF  65535|
|             | User Defined Graphics
|0xFF58  65368| <-- SP
|-------------|
|0xFF58  65367| Z88DK program's stack
| (512 bytes) | Grows downwards, remember!
|0xFD57  64855|
|-------------|
|0xFD56  64854|
|             |
|             | Z88DK heap memory
|             |
|             |
|-------------|
|             | Z88DK BSS section  (CRT_ORG_BSS)
|             | Z88DK DATA section (CRT_ORG_DATA)
|-------------| ^^^
|             |
|0x8000  32768| Z88DK compiled C   (CRT_ORG_CODE)
|-------------|
|             | Lower RAM, includes basic program,
|             | sys vars, print buffer, etc.
|             | Slower, "contended memory"
|-------------|
|0x5AFF  23295|
|             | Display File (i.e. screen memory)
|0x4000  16384|
|-------------|
|0x3FFF  16383|
|             | ROM
|0x0000      0|
+-------------+
```

We need to find somewhere in there where 257 bytes won't cause a problem, and
that 257 byte block needs to be on a 256 byte boundary because we only get to
specify the high byte of its address. We can't put it in the ROM or screen
areas, and we can't put it somewhere where the stack or heap are likely to grow
into because it will be corrupted. So where's good?

By default the stack starts at address 0xFF58, as shown in the illustration
above. We can move it if we want to, but that's a sensible place if we're to
preserve the UDGs. So let's leave it there. The highest memory location we can
place our 257 byte vector table below the stack is therefore 0xFE00-0xFF00
inclusive, but that would only give the stack 87 bytes (0x57 hex) bytes to grow
down into. That would be too tight for all but the simplest program, so let's
put the vector table 512 bytes lower, occupying memory locations 0xFC00-FD00
inclusive. That will give our stack 600 bytes to grow down into:

```
|-------------|
|0xFF58  65368| Z88DK program's stack
|             | (600 bytes total)
|0xFD01  64769|
|-------------|
|0xFD00  64768| IM 2 vector table
|             | (257 bytes total)
|0xFC00  64512|
|-------------|
|             |
|             |
|             | Z88DK heap memory
|             |
|             |
|-------------|
|             | Z88DK BSS section  (CRT_ORG_BSS)
|             | Z88DK DATA section (CRT_ORG_DATA)
|-------------| ^^^
```

This vector table needs to be filled with 257 bytes, all the same. They make up
an address of a jump instruction. Because the high and low bytes must be the
same we're restricted in the vector address we can use. Again, anywhere suitable
will do the job, but we keep to our plan of putting things as high up in memory
as possible. 0xFFFF is the top of memory, so that's no good. 0xFEFE and 0xFDFD
are the next ones down, but those are in the stack area. Next would be 0xFCFC
which is in our vector table so that's no use either. Next one down is
0xFBFB. Ah, this looks better. That's just below the vector table. We need 3
bytes, so we can use the bytes at 0xFBFB, 0xFBFC and 0xFBFD:

```
|-------------|
|0xFF58  65368| Z88DK program's stack
|             | (600 bytes total)
|0xFD01  64769|
|-------------|
|0xFD00  64768| IM 2 vector table
|             | (257 bytes total)
|0xFC00  64512|
|-------------|
|0xFBFD       | IM 2 JMP instruction
|0xFBFC       | (3 bytes total)
|0xFBFB       |
|-------------|
|             |
|             |
|             | Z88DK heap memory
|             |
|             |
|-------------|
|             | Z88DK BSS section  (CRT_ORG_BSS)
|             | Z88DK DATA section (CRT_ORG_DATA)
|-------------| ^^^
```

So our situtation now is that the Z88DK program, with its DATA and BSS sections
and heap, start (by default) at 0x8000 (32768) and grow upwards. The top byte of
the heap will be 0xFBFA, above which is our JMP instruction, then the vector
table, then the 600 byte stack, then the UDGs. This is a reasonably compact and
memory efficient arrangement.

Having worked all that out, we can now look at the program which arranges it.

### Example Code

Here's a piece of code which sets up interrupt mode 2 routine as per the
discussion above:

'''
#pragma output REGISTER_SP = 0xFF58

#include <z80.h>
#include <string.h>
#include <intrinsic.h>
#include <im2.h>
#include <arch/zx.h>

IM2_DEFINE_ISR(isr)
{
  *(unsigned char*)0x4000 = 0x55;
}

#define TABLE_HIGH_BYTE           ((unsigned int)0xfc)
#define INT_JUMP_POINT_HIGH_BYTE  ((unsigned int)0xfb)

#define UI_256                    ((unsigned int)256)

#define TABLE_ADDR                ((void*)(TABLE_HIGH_BYTE*UI_256))
#define INT_JUMP_POINT            ((unsigned char*)( (unsigned int)(INT_JUMP_POINT_HIGH_BYTE*UI_256) + INT_JUMP_POINT_HIGH_BYTE ))

int main()
{
  memset( TABLE_ADDR, INT_JUMP_POINT_HIGH_BYTE, 257 );

  z80_bpoke( INT_JUMP_POINT,   195 );
  z80_wpoke( INT_JUMP_POINT+1, (unsigned int)isr );

  im2_init( TABLE_ADDR );

  intrinsic_ei();

  while(1);
}
'''

Save this to a file called im2_simple.c and compile it with this command:

'''
zcc +zx -vn -clib=sdcc_iy -startup=31 im2_simple.c -o im2_simple -create-app
'''

This is our typical, simplest compile command, using the stripped down CRT31. It
deliberately uses C macros to define the salient values, and they will be
discussed on a moment. If you run it you'll notice that a) the Spectrum locks
up, and b) a small dashed line appears in the top left corner of the
screen. Let's look at the code to see what's happening.


### Conclusion

Now that we've seen how programs are laid out in memory, we can have a better 
look at the BiFrost library.
Part 7 is [here](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_07_BiFrost.md)
