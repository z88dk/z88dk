# ZX Spectrum Development with Z88DK - Multiple Files

This is the fifth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 4](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_04_InputDevices.md).

If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

The reader is assumed to be familiar with the idea of linking object files
together within the context of a C program.

The reader is also assumed to be familiar with the concept and basic content of
a Z80 assembly language file.

The makefile section assumes the reader understands GNU make, or their preferred
make utility.

## Multiple C Source Files

So far in this series of articles we've only ever had examples consisting of a
simple piece of code within a single C source file. That's not realistic for any
project of any size, so we need to look at how we can break our source into
multiple files.

This is going to be a brief introduction. Using multiple files isn't complicated
with Z88DK, and the nuances and caveats that there are won't be discussed
here. We simply introduce the concept so the reader can see how to keep their
build clear and understandable as it gets bigger.

As always, we start simple. Here's a source file containing a *main()* function:

```
/* C source start */

#include <stdio.h>

extern unsigned char message[];

int main()
{
  printf("Message is: \"%s\"\n", message);

  return 0;
}

/* C source end */
```

Save that into a file called *text_main.c*, then save this into a file called
*text_data.c*:

```
/* C source start */

unsigned char message[] = "Hello, world!";

/* C source end */
```

To compile both files and link them together into the final application just
give both file names on the compile line:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy text_main.c text_data.c -o text -create-app
```

Both files will be compiled each time the application is built.

### Project Lists

Two filenames on the command line isn't a problem, but as a project gets bigger
and the list of its files gets longer it becomes more convenient to put those
filenames into a single list file and use that on the command line instead.

Create a file called *text.lst* containing these lines:

```
text_main.c
text_data.c
```

and compile with the list file, indicated by the preceding '@' symbol:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy @text.lst -o text -create-app
```

It does what you'd expect. You can use filenames containing subdirectory names,
so you can break your build up into subdirectories as required.

You can also add list files into list files by using the same '@' symbol, so
your first list file might contain:

```
game_code.c
@data/data.lst
```

That's one C file and a second list file in the *data/* subdirectory. The
*data/data.lst* file might contain:

```
graphics_data.c
music_data.c
text_data.c
```

All the data files listed in *data/data.lst* would be compiled and linked with
*game_code.c* as you'd expect.

## Adding Z80 Assembly Language

This guide isn't the place to introduce Z80 assembly language or how it can be
used with Z88DK, but we can demonstrate how to bring a Z80 assembly language
file into our build. In fact, since the *zcc* front end tool knows how to deal
with assembly language files it's quite trivial.

Copy this assembly language into a file called *text_data.asm*:

```
SECTION rodata_user

PUBLIC _message

_message:

defb 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x41, 0x53, 0x4D, 0x00
```

Build the application with:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy text_main.c text_data.asm -o text -create-app
```

The *zcc* tool recognises the ASM file and knows it has to be passed to the
assembler, as opposed to the C compiler. Once assembled, *zcc* links the assembly
language into the application and makes its contents available to the C code.

## Makefiles

Once a project gets to a reasonable size it makes sense to start using
makefiles.  The SDCC compiler can be very slow when optimising so deploying a
makefile can speed up builds quite considerably. For this worked example we use
the GNU *make* utility on Linux, although any variant can be used with a little
tweaking.

We need another assembly language file to play with, so save this text to a file
called *text_via_makefile.asm*:

```
SECTION rodata_user

PUBLIC _message

_message:

defm "This version is built from a makefile", 0x00
```

Here's a sample makefile which will build the program, resulting in a TAP file:

```
CC=zcc
AS=zcc
TARGET=+zx
VERBOSITY=-vn
CRT=4

PRAGMA_FILE=zpragma.inc

C_OPT_FLAGS=-SO3 --max-allocs-per-node200000

CFLAGS=$(TARGET) $(VERBOSITY) -c $(C_OPT_FLAGS) -compiler sdcc -clib=sdcc_iy -pragma-include:$(PRAGMA_FILE)
LDFLAGS=$(TARGET) $(VERBOSITY) -clib=sdcc_iy -pragma-include:$(PRAGMA_FILE)
ASFLAGS=$(TARGET) $(VERBOSITY) -c


EXEC=text.tap
EXEC_OUTPUT=text

OBJECTS = text_main.o \
          text_via_makefile.o

%.o: %.c $(PRAGMA_FILE)
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

all : $(EXEC)

$(EXEC) : $(OBJECTS)
	 $(CC) $(LDFLAGS) -startup=$(CRT) $(OBJECTS) -o $(EXEC_OUTPUT) -create-app

.PHONY: clean
clean:
	rm -f *.o *.bin *.tap *.map zcc_opt.def *~ /tmp/tmpXX*
```

**If you copy and paste the makefile example above, ensure you end up with tab
characters in the rule lines, not spaces.**

This isn't the place to learn about makefiles, and since everyone does it a
bit differently we'll just review the salient points.

What we're putting together here is called a *split build*, which is where the
various parts of a software package are (at least potentially) built separately
from each other. The key with split builds is to ensure all components of
the software use the same tools, flags, options, and so on.

```
CC=zcc
AS=zcc
TARGET=+zx
VERBOSITY=-vn
CRT=4
```

Firstly, we use the Z88DK front end utility *zcc* as both the C compiler (which
it fronts for *sdcc*) and the assembler (which it fronts for *z80asm*). Using
the underlying tools is perfectly possible, but *zcc* makes life a lot easier,
at least at first. We also define our [target platform](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md#build-a-compile-command) and [CRT](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md#crts-for-reference) up front
to make them easier to change should we want to.

```
PRAGMA_FILE=zpragma.inc
```

We define a separate file for our *pragma* declarations. We haven't seen pragmas
yet. They will be introduced in the [next
article](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_06_SomeDetails.md#changing-the-memory-layout)
where they are embedded into the C source. When using split builds it's easier
to put them all into a separate file used by all the tools. This ensures they're
used consistently. Don't worry about this detail until you need pragmas. For now
just create an empty file to allow the build to progress:

```
> touch zpragma.inc
```

Next we set up the flags for the compile, link and assembler tools:

```
C_OPT_FLAGS=-SO3 --max-allocs-per-node200000

CFLAGS=$(TARGET) $(VERBOSITY) -c $(C_OPT_FLAGS) -compiler sdcc -clib=sdcc_iy -pragma-include:$(PRAGMA_FILE)
LDFLAGS=$(TARGET) $(VERBOSITY) -clib=sdcc_iy -pragma-include:$(PRAGMA_FILE)
ASFLAGS=$(TARGET) $(VERBOSITY) -c
```

To keep all pieces of a split build consistent we specifically state the
compiler we want to use (SDCC) together with the C library (sdcc_iy). The C
library option needs to be given to both the compiler and linker. The
optimisation flags are separate so they can be switched off easily.

```
%.o: %.c $(PRAGMA_FILE)
	$(CC) $(CFLAGS) -o $@ $<
```

This is the standard *C-file-to-Object-file* implicit compilation rule. We've
added the pragma file to it so all C files will be recompiled if the pragma file
changes.

```
%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<
```

This is an additional rule which defines how to create an object file from an
assembly language file. We just call the assembler with the correct
flags. (Actually, GNU make's implicit rule works fine if you don't mind your
assembly language files having .s extensions.)

```
$(EXEC) : $(OBJECTS)
	 $(CC) $(LDFLAGS) -startup=$(CRT) $(OBJECTS) -o $(EXEC_OUTPUT) -create-app
```

Finally this is the build line which uses *zcc* to bring together the built
object files and create a Spectrum application from them.

The output from this makefile is:

```
>make all
zcc +zx -vn -c -SO3 --max-allocs-per-node200000 -compiler sdcc -clib=sdcc_iy -pragma-include:zpragma.inc -o text_main.o text_main.c
zcc +zx -vn -c -o text_via_makefile.o text_via_makefile.asm
zcc +zx -vn -clib=sdcc_iy -pragma-include:zpragma.inc -startup=4 text_main.o text_via_makefile.o -o text -create-app
```

The first line compiles *text_main.c*, the second assembles *text_via_makefile.asm*,
and the third links the objects and creates the Spectrum TAP file.

## Where To Go From Here

This has been a brief introduction to the ability of zcc to handle multiple
files and file types all in one build. We've scratched the surface and
demonstrated a couple of useful features of zcc. It's a powerful and flexible
tool which is worth exploring, and is documented
[here](https://www.z88dk.org/wiki/doku.php?id=zcc)

The next installment in this series takes a step back and looks at some of the
details of how Z88DK C programs are arranged in memory.
Part 6 is [here](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_06_SomeDetails.md)
