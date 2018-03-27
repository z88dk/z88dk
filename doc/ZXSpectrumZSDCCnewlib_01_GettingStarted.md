# ZX Spectrum Development with Z88DK - Getting Started

This document describes how to get started writing ZX Spectrum programs using
Z88DK. It concerns itself only with the newer, more standards compilant zsdcc C
compiler. The original sccz80 compiler is not discussed.

Further, this document only concerns itself with the 48K ZX Spectrum. Topics
concerned with the later machines, like memory bank switching, are not covered
here.

## Purpose

There is a lot of documentation scattered around the Z88DK package, but it's
frequently tricky for a new user to sort out what's relevant to their goal and
hence what they should be reading. The purpose of this document is to introduce
the reader to developing C code for the ZX Spectrum using the newer compiler,
tools and libraries found in Z88DK.

Z88DK covers around 50 Z80 based machines. This document covers exactly one of
them.

Z88DK has two C compilers which can build ZX Spectrum programs. This document covers
only one of them.

Z88DK has two C libraries containing code that implements the standard and extensions.  This document covers one of them.

## Assumptions

It is assumed the reader has installed the [Z88DK development
kit.](https://www.z88dk.org/wiki/doku.php?id=temp:front)

The reader is assumed to have read at least the
[README.md](https://github.com/z88dk/z88dk/blob/master/README.md) document which
introduces the Z88DK development kit, and the
[overview.md](https://github.com/z88dk/z88dk/blob/master/doc/overview.md)
document which describes some of the approaches and tools used. A complete
understanding of the technical contents of these documents is not required.

The zsdcc compiler is supplied in some Z88DK distribution packages, and requires
building for others. It is assumed the reader has either [obtained or
built](https://www.z88dk.org/wiki/doku.php?id=temp:front#sdcc1) a working
version of the zsdcc C compiler.

The Z88DK tools require the $ZCCCFG environment variable to be set correctly,
and the $PATH environment variable to contain the path to the Z88DK
toolset. Information is
[here](https://www.z88dk.org/wiki/doku.php?id=temp:front#installation) and the
reader is assumed to have these set correctly.

All examples in this document use Linux. Although Z88DK is generally platform
agnostic, there are small differences between platforms with file path formats
and so on. Users on non-Linux platforms are assumed to be able to make the
necessary conversions.

The reader is assumed to be using a ZX Spectrum emulator, as opposed to real
hardware. The example used will be
[Fuse](http://fuse-emulator.sourceforge.net/), but any should work. The emulator
should be set to 48K mode.

Finally, the user is assumed to know the C programming language. Details will be
discussed, but the user is assumed to be able to read a simple C program.

## Check The Tools

The first step is to check the necessary tools are in place. Running each of
these commands should produce something similar to the output given:
```
  >zcc
  zcc - Frontend for the z88dk Cross-C Compiler
  <pages and pages of help and options snipped>
```
```
  >zsdcc -v
  ZSDCC IS A MODIFICATION OF SDCC FOR Z88DK
  Build: 3.6.6 #9921 (Linux) Jun  2 2017
```
```
  >z80asm
  Z80 Module Assembler 2.8.5, (c) InterLogic 1993-2009, Paulo Custodio 2011-2017
```
```
  >appmake 
  appmake [+target] [options]
  
  The z88dk application generator
  <pages and pages of help and options snipped>
```
If these all work, we're ready to begin. If any of them don't, those problems
need solving before going any further.

## Program 1 - Black Border

As a starting point, both for discussion and development processes, we're going
to get this program to compile and run:
```
  /* C source start */
  
  #include <arch/zx.h>
  
  int main()
  {
    zx_border(INK_BLACK);
    return 0;
  }
  
  /* C source end */
```
Details will follow, but for now it should be pretty obvious what this program
will do. Copy this text into a file called black_border.c.

### Build a Compile Command.

The Z88DK front end tool for the zsdcc compiler is zcc. In order to make it
build code for a Spectrum, as opposed to any of the dozens of other machines
Z88DK supports, it needs the +zx target as its first argument. So all our
compilation commands will start with:
```
  >zcc +zx ...
```
zcc output can be noisy, which is frequently useful but initially confusing. So
for the time being we're going to turn down the verboseness of the output using
the -vn flag:
```
  >zcc +zx -vn ...
```
zcc can utilise either of the C compilers in Z88DK; for the purposes of this
guide we're only using the newer, more standards compliant one, zsdcc. Which
compiler is used depends on the compile line switch which sets the library to
use. Yes, really: you set the library to choose the compiler.

The library, in this context, is the store of standard subroutines which
Spectrum programmers will find useful. There are several of these standard
libraries, and for this guide the most suitable one is the one called
'sdcc_iy'. Details of why are, unfortunately, an advanced topic; for now, just
understand that this is the library to use when getting started and using it on
the command line automatically invokes the new compiler which is what we
want. The zcc argument to select the library is -clib, so now the command line
is:
```
  >zcc +zx -vn -clib=sdcc_iy ...
```
Next we need to specify a C runtime. This is a small piece of code which is
inserted before the programmer's C code. It sets up memory usage, how the
program will exit, and various other things to do with how the keyboard is read
and the screen is used. On some of the machines supported by Z88DK this sort of
thing is important, but it is less so for the ZX Spectrum, especially if the
intention is to write graphics based programs such as games. Therefore the most
basic C runtime is the one for us to use. The C runtimes are numbered rather
than named, and it happens that the one numbered '31' is the most minimalistic
one. Hence that's the one to use:
```
  >zcc +zx -vn -clib=sdcc_iy -startup=31 ...
```
Now we specify the input C file. You saved the example code to a file called
black_border.c, so:
```
  >zcc +zx -vn -clib=sdcc_iy -startup=31 black_border.c ...
```
Now for the output. zsdcc produces a bunch of output files, none of which are of
any interest when getting started other than the final runnable. Nevertheless,
they have to be called something so we must specify the basename for these
files.  Extensions like ".bin" are frequently used, but no extension
works just as well:
```
  >zcc +zx -vn -clib=sdcc_iy -startup=31 black_border.c -o black_border ...
```
One more thing to add. The output from the C compiler is Z80 machine code, but
we need a way to get it into a Spectrum. Spectrums, as we all know, use tapes,
so we need to bundle up our program into a TAP archive so the Spectrum can LOAD
it.

There's a tool to do exactly that called appmake, but we don't need to know the
details of that because zcc will handle it for us. Adding the appropriate
argument brings us to our final command line:
```
  >zcc +zx -vn -clib=sdcc_iy -startup=31 black_border.c -o black_border -create-app
```
Running this command should produce a file called black_border.tap. If it
doesn't it's easier to ask in the Z88DK support forum than it is to try to work
out why.

In Fuse, the longwinded but satisfyingly traditional way of loading a TAP file
is to use Media->Tape->Open to specfiy the TAP file (which "inserts the cassette
into the cassette player"), then on the emulated Spectrum type LOAD "" and press
ENTER. Then use Media->Tape->Play to "start the cassette playing". You then get
to watch the borders flicker and listen to noises so familiar in the 1980s.

In practise, you can just drag and drop the black_border.tap file onto the Fuse
window and watch the program run. The TAP's BASIC loader will load and run,
which in turn will load and run the Z88DK created machine code.

Now we finally get to see what the program does. It turns the border black.

### Examining the Black Border Code

Let's cover a couple of details which aren't massively important, but which
might be useful to complete the picture of what's happening.

#### Header Files

The first line of the program is:
```
  #include <arch/zx.h>
```
but where does this file come from? The Z88DK installation contains hundreds of
header files and only a some of them are for use with zsdcc and the
Spectrum.

The answer can be found by running our compilation command again with -v instead
of -vn and looking for the -I argument on the zsdccp command. How this affects
the compilation is beyond the scope of a getting started guide, but suffice to
say it shows that when using the zsdcc compiler the header files come from this
directory:
```
 include/_DEVELOPMENT/sdcc
```
so the header file being included in this example is:
```
 include/_DEVELOPMENT/sdcc/arch/zx.h
```
It's sometimes quicker to browse the header files in a web browser. The base
link is [here](https://github.com/z88dk/z88dk/tree/master/include/_DEVELOPMENT/sdcc).

That [arch/zx.h](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx.h) file contains the value for the INK_BLACK macro and a prototype
for the zx_border() function.

It's important not to be distracted by all the other header files in the
system. The relevant ones are those for the zsdcc compiler.

#### Library Files

Another question which might be asked of this tiny example is, where does the
zx_border() code come from? The answer is the sdcc_iy standard library specified
in the zcc compilation command via the -clib argument.

Another peek at the output of zcc with the -v argument shows a -L argument being
passed into an embedded z80asm command. Again, details are beyond the scope of
this document, but the value for that argument tells us that the library code is
coming from:
```
 libsrc/_DEVELOPMENT/lib/sdcc_iy
```
The contents of this directory are built during the Z88DK build, so you can't
browse it online.

On your local machine you'll find there are several library files in there
which together make up the entire sdcc_iy library. Any of those files can supply
code for a zsdcc compiled program. The important one for Spectrum programmers is
zx.lib. That library file is full of optimised Z80 machine code routines which
provide the sorts of features Spectrum programs need. If you're interested you
can inspect the contents of the library with the z80nm command:
```
>z80nm zx.lib | less
```
Do a search and you'll find the zx_border() function listed in there.

The actual source code used to build the library is rooted in [z88dk/libsrc/_DEVELOPMENT](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT)
and a search using the header path `arch/zx` as clue locates the [asm_zx_border.asm](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/arch/zx/misc/z80/asm_zx_border.asm) function in `arch/zx/misc/z80`.

[... continue to Part 2: Hello World](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md)
