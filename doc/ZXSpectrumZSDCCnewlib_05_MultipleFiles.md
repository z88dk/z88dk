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

## Multiple C Source Files

So far in this series of articles we've only ever had examples consisting of a
simple piece of code within a single C source file. That's not realistic for any
project of any size, so we need to look at how we can break our source into
multiple files.

This is going to be a brief introduction. Using multiple files isn't complicated
with Z88DK, and the nuances and caveats that there are won't be discussed
here. We simply introduce the concept so the reader can see how to keep their
build clear and understandable as it gets bigger.

As always, we start simple. Here's a source file containing a main() function:

```
/* C source start */

#include <stdio.h>

extern unsigned char* message;

int main()
{
  printf("Message is: \"%s\"\n", message);

  return 0;
}

/* C source end */
```

Save that into a file called text_main.c, then save this into a file called
text_data.c:

```
/* C source start */

unsigned char* message = "Hello, world!";

/* C source end */
```

To compile both files and link them together into the final application just
give both file names on the compile line:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy text_main.c text_data.c -o text -create-app
```

Both files will be compiled each time the application is built. We're not going
to look at Makefiles here, although zsdcc can be slow so you should plan to use
one for any sizeable project.

### Project Lists

Two filenames on the command line isn't a problem, but as a project gets bigger
and the list of its files gets longer it becomes more convenient to put those
filenames into a single list file and use that on the command line instead.

Create a file called text.lst containing these lines:

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

That's one C file and a second list file in the data/ subdirectory. The
data/data.lst file might contain:

```
graphics_data.c
music_data.c
text_data.c
```

All the data files listed in data/data.lst would be compiled and linked with
game_code.c as you'd expect.

## Adding Z80 Assembly Language
