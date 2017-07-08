# ZX Spectrum Development with Z88DK - Sprite Libraries

This is the sixth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 5](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_05_MultipleFiles.md).

If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Z88DK's ZX Spectrum Sprite Libraries

Intro

### SP1

### BiFrost

BiFrost is a multicolour sprite library written by Einar Saukas, which has been
embedded and interfaced with the Z88DK C development kit. "Multicolour" means
it's capable of drawing blocks of pixels which are 8 pixels wide by 1 pixel
high, each with 2 colour attributes. This works much the same way as the
Spectrum's native 8x8 pixel blocks which have the INK and PAPER attributes, but
since BiFrost's blocks occupy 1 pixel row instead of 8, the programmer can get a
much more colourful display.

There are 2 versions of BiFrost, the original and BiFrost2. Somewhat
confusingly, the original BiFrost also comes in 2 versions, low resolution and
high resolution. Which of the 3 versions you chose depends on what capabilities
you require.

Technical limitations mean BiFrost can't use the whole screen. It's restricted
to 18 character rows by 18 character columns. That's 144x144 pixels. The low
resolution version of BiFrost can place a 16x16 pixel multicolour sprite at 8
pixel boundaries. The high resolution version of BiFrost can place a multicolour
sprite at any pixel, at the expense of more memory consumption are greater CPU
processing requirement over the low resolution version.

BiFrost2 is an improvement on the high resolution version of BiFrost. It can
place a 16x16 pixel multicolour sprite at any pixel, and can do so within a
20x20 character grid. That's a 160x160 pixel area of the screen.

#### Building a BiFrost Program

BiFrost based programs created with Z88DK load in a slightly different way to
most Spectrum programs. The compliation process generates _two_ blocks of
machine code. The first is the programmer's code, the compiled C, as usual. The
second is the BiFrost library itself, which is loaded separately into a
specifically allocated area of high memory. The details of why aren't really
important at this getting started level. The important thing is to understand
the loading process the Spectrum will have to go through:

* load and run a BASIC loader
* the BASIC loader loads the programmer's CODE into memory
* the BASIC loader then loads the BiFrost library CODE into higher memory
* the BASIC loader then runs the programmer's code

The programmer's code, created by Z88DK, expects to find the BiFrost library
loaded and waiting to be run at the correct address. As long as the BASIC loader
has loaded BiFrost into the correct area of memory this will work as expected.

Step 1, therefore, is to create a BASIC loader program. Yes, you're going to
type a bit of Spectrum BASIC. Here it is:

```
10 CLEAR 32767
20 LOAD "" CODE
30 LOAD "" CODE
40 RANDOMIZE USR 32768
```

This needs to be saved to a .TAP file. The exact steps for doing this depend on
the emulator you're using. On Fuse you would use Media->Tape->Clear to clear the
emulator's "virtual tape", then save the program with:

```
SAVE "biloader" LINE 10
```

Once that's complete, write out the "virtual tape" to a file called
bifrost_loader.tap using Media->Tape->Write. That's the loader part completed.

Step 2 is to create a coloured tile, which is the sprite BiFrost will draw onto
the screen. <COME BACK TO THIS>

Step 3 is to create a small program which uses BiFrost. Save this to
bifrost_01.c:

```
???
```

and compile it with this:

```
zcc +zx -vn -startup=31 -clib=sdcc_iy bifrost_01.c ctile.asm -o bifrost_01
```

We use crt31 since we're not using the standard IO. Also note there's no
specific mention of the BiFrost library on the compile line. For Spectrum
programs Z88DK's standard library makes BiFrost available automatically.

Once this has run you'll notice it's created two binary files in the local
directory:

```
bifrost_01_CODE.bin
bifrost_01_BIFROSTL.bin
```

The first of those is programmer's code, the second is the BiFrost
library. These files contain raw machine code, so we need to convert them into
.TAP files which the Spectrum can load via the BASIC loader we've already
created. In previous examples we've used zcc's -create-app option to do this
step, but since we're now working with multiple code files which are beyond
zcc's remit we need to do it manually. 

The command to convert a binary machine code file to a .TAP file is _appmake_
and for our first piece of code we build a command as follows.

Our target machine, as ever, be a ZX Spectrum:

```
appmake +zx ...
```

Our binary input file is bifrost_01_CODE.bin:

```
appmake +zx -b bifrost_01_CODE.bin ...
```

and the output file will be bifrost_01_code.tap:

```
appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap ...
```

By default the appmake utility produces a little BASIC loader program to load
machine code. In this case we've already written our own, so we need to suppress
that:

```
appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap --noloader ...
```

Next we need to specify where the piece of code will be LOADed. This value goes
into the tape header so when you type _LOAD "" CODE_ (i.e. without a specific
load address) the Spectrum can work out where in memory it's expected to load
the code. By default Z88DK compiled code expects to load and run from address
32768, so:

```
appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap --noloader --org 32768 ...
```

Finally we need to provide a name for the block of CODE on the tape:

```
appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap --noloader --org 32768 --blockname bifrost_01_code
```

We have to create two pieces of tape loadable code for our BiFrost project, the
second containing the BiFrost code which expects to load and run from address
58625. So the two commands to create the .TAP files are:

```
appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap --noloader --org 32768 --blockname bifrost_01_code
appmake +zx -b bifrost_01_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname bifrostl
```

Finally, we need to merge our 3 tape files into a single one. The .TAP format is
a very simple one which allows direct concatenation of .TAP files in order to
make a single big one, so on Linux the command is:

```
cat bifrost_loader.tap bifrost_01_code.tap bifrostl.tap > bifrost_01.tap
```

This is all a bit fussy to keep typing, so maybe it's time for a makeifle:

```
all: bifrost_01.tap

bifrost_01_CODE.bin: bifrost_01.c ctile.asm coloured_ball.ctile
	zcc +zx -vn -startup=31 -clib=sdcc_iy bifrost_01.c ctile.asm -o bifrost_01

bifrost_01_code.tap: bifrost_01_CODE.bin
	appmake +zx -b bifrost_01_CODE.bin -o bifrost_01_code.tap --noloader --org 32768 --blockname bifrost_01_code
	appmake +zx -b bifrost_01_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname bifrostl

bifrost_01.tap: bifrost_01_code.tap
	cat bifrost_loader.tap bifrost_01_code.tap bifrostl.tap > bifrost_01.tap
```

Clearly this makefile could be made more streamlined, or more generic, but it
works for this example.


and the output file is the .TAP file for the Spectrum
to load. --noloader tells appmake not to create a BASIC loader (which it does by
default) since we already have our our, and to ensure the machine code is saved
such that it loads at address 32768, which is where Z88DK code expect to run
from by default.


###

### Nirvana

Two versions, Nivana and Nivana+. They only differ in the screen size and what
happens when a sprite is positioned at the edge of the screen.

Speccy has 8x8 pixel blocks with one INK/PAPER attribute used to colour
them. Nirvana uses what's termed a "bi-colour" pixel block which is 8x2 pixels
with one INK/PAPER attribute. 