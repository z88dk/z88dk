# ZX Spectrum Development with Z88DK - Some Details

This is the sixth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

This document relates specifically to the 48K Spectrum. Other models have more
complex memory management and are not covered here.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 5](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_05_MultipleFiles.md).

If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Z88DK's Memory Map, Stack, and Other Details

In previous installments we've looked at how to get started writing C programs
for the ZX Spectrum using Z88DK. As things are inevitably getting more complex,
it's time to take a step back and try to understand a few details of what's
happening under the covers. We're not going to look at all the complexities,
just the ones which will be useful to know as we move forward.

By default a Z88DK Spectrum program will be compiled such that its code
originates at address 32768. This is one of the numerous configuration
parameters defined in the C Runtime Configuration file
[here](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/target/zx/crt_config.inc#L19):

```
libsrc/_DEVELOPMENT/target/zx/crt_config.inc
```

Skim read this file and you'll find the CRT_ORG_CODE value set to 32768. You'll
also find the stack register is initially set to 65368 (REGISTER_SP) which
places it immediately below the user defined graphics area. This is so that if
the program returns to BASIC the UDGs will still be intact. The stack size is set to 
512 bytes. There's quite a few other things in there too, and they're documented
[here](https://www.z88dk.org/wiki/doku.php?id=libnew:target_embedded#crt_configuration).

So by default the Spectrum's memory map for a Z88DK program is:

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

By default the DATA section, which contains initialised variables, and the BSS
section, which contains uninitialised variables, sit directly above the
compiled code. The bigger the code gets, the higher in memory these sections are
placed. The heap, which is the area of memory Z88DK's "malloc" allocates memory
from, sits between the BSS section and the stack. In a C program which malloc()s
and free()s working memory as it runs, this heap area is the program's "dynamic
memory."

So far in this series we've used the default values for the runtime
configuration so our programs will have run in a layout like the one shown
above. But we're heading into places where we need to be more aware of what's
going on, so getting a mental picture of the above layout will be useful.

### Changing the Memory Layout

There are several ways to change the default settings of a Z88DK compile but the
simplest approach is to use special statements called _pragma_s to change these
settings.  Pragmas are compiler specific extensions to the C language that can
override the default CRT configuration at compile time.

For a large project, these pragmas can be collected into a single file, for example
"zpragma.inc", and can be incorporated into the compile using `-pragma-include:zpragma.inc`
on the compile line.

However for small projects with few source files, it can be more convenient just
to include them within the C code itself like this:

```
#pragma output CRT_ORG_CODE = 36864
```

You can put these anywhere in the source files you like. This one would push the
compiled C 4KB up in memory from the usual org address of 32768. If you need to do
something like this remember to change your BASIC loader to:

```
RANDOMIZE USR 36864
```

since that's where your code will now be loaded.  If you use `-create-app` on the
compile line, z88dk automatically does this for you in the tap file it creates.

Here's an interesting pragma to move the initial stack location:

```
#pragma output REGISTER_SP           = -1
```

Setting the stack pointer to the special value of -1 means "don't move it." In
this case the stack will remain where the BASIC loader left it, which is just
below the location of the CLEAR command in the loader. If your loader starts
with:

```
10 CLEAR 32767
```

and your program loads into the default location of 32768, the stack will start
just beneath your program and grow down towards the screen. That's slower,
contended memory, but the stack would be out of the way of the heap, which might
be useful if your program needs lots of heap space:

```
|             |
|             |
|0x8000  32768| Z88DK compiled C   (CRT_ORG_CODE)
|-------------|
|0x7FFF  32767| Z88DK program's stack
|             | Grows downwards, remember!
|             |
```

On the other hand, you can turn off the heap entirely with:

```
#pragma output CLIB_MALLOC_HEAP_SIZE = 0
```

The default heap size on Spectrum programs is set to -1, which is a special
value which says "use all the memory above the program's BBS section and the
below the stack for heap." This is frequently the best option since it allows
the program to malloc as much memory as possible as it needs it. The problem is
that the heap memory is formatted for allocation with malloc():

```
|             |
|-------------|
|0xFF58  65368| Z88DK program's stack
| (512 bytes) | Grows downwards, remember!
|-------------|
|xxxxxxxxxxxxx|
|xxxxxxxxxxxxx|
|xxxxxxxxxxxxx| Z88DK heap memory
|xxxxxxxxxxxxx|
|xxxxxxxxxxxxx|
|-------------|
|             | Z88DK BSS section  (CRT_BSS_DATA)
|             | Z88DK DATA section (CRT_ORG_DATA)
|-------------| ^^^
|             |
|0x8000  32768| Z88DK compiled C   (CRT_ORG_CODE)
|-------------|
|             |
```

Normally that's fine, but if you've already loaded something else into that
memory, having it initialised (e.g. reset to zeroes) in order to use as heap
would be unwelcome. Specifically setting a heap size to zero (or, if you do
actually need some heap, any other amount which leaves your valuable memory
areas alone) stops this initialisation of memory. As we'll see in another
installment, this type of heap control is required to protect the area of memory
the BiFrost multicolour library uses for itself.

### Where To Go From Here

Now that we've seen how programs are laid out in memory, we can have a better 
look at the BiFrost library.
Part 7 is [here](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_07_BiFrost.md)
