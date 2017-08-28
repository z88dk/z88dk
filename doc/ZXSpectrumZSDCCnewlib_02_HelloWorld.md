# ZX Spectrum Development with Z88DK - Hello World

This is the second document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

## Assumptions

It is assumed the reader has worked through the [first installment of this
series](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Purpose

It might be a reasonable assumption that most people picking up Spectrum
programming for the first time are looking to write games, and so are interested
in sprites, joysticks, music, and so on. First things first, however. Simple
text based programs allow programmers to experiment with library routines, to
feed them inputs and see the outputs. Runtime debugging will go a long way away in
this "getting started" series, so for the time being text IO is going to be
useful.

## stdio

This guide introduces standard IO on the Spectrum. In some ways stdio feels a
rather odd concept to a Spectrum programmer unfamiliar with Z88DK. Spectrum text
input and output is traditionally based around the ROM routines accessed from
BASIC and hence is extremely simple. stdio, from the world of C, is vastly more
powerful. It looks a bit strange in 32 columns.

The stdio library talks to a "driver." A driver is some Z88DK code that is
attached to the end of a byte stream.  These drivers can handle screen output
and keyboard input like PRINT and INPUT do in basic.

### Hello World

We need to start at the beginning, and the beginning for standard IO is, of
course, "hello world". Here's the Spectrum version which you should save to a
file called hello_world.c:

```
  /* C source start */

  #include <arch/zx.h>
  #include <stdio.h>

  int main()
  {
    zx_cls(PAPER_WHITE);

    puts("Hello, world!");

    return 0;
  }

  /* C source end */

```

Recalling the command line we built for our zsdcc compiles using Z88DK's sdcc_iy
library in the first installment of this series, we need to make a tweak to the
C runtime we're using. We were using crt number 31 which turns off all the stdio
channels to save some memory. Since we now want to use those channels we need to
use a C runtime which enables them. crt 0 does so, and sets the screen up in the
Spectrum's traditional 32x24 character display, so that's the one to use. Our
compile line is therefore:

```
 zcc +zx -vn -startup=0 -clib=sdcc_iy hello_world.c -o hello_world -create-app
```

Run that compilation and drag and drop the resultant TAP file onto the Fuse
window. It does what you'd expect, Spectrum style.

The [zx.h](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx.h) header file is found here:

```
 include/_DEVELOPMENT/sdcc/arch/zx.h
```

and you'll notice it contains the declaration of the zx_cls() function. There's
no documentation for that function beyond the header file, but it's a reasonable
assumption that it clears the screen. A little experimentation shows that its
argument changes the colour attribute of the screen. Try changing the
PAPER_WHITE constant to PAPER_YELLOW to confirm this. The scarcity of
documentation makes this sort of investigation necessary for Z88DK development
as things stand.

The [stdio.h](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/stdio.h) header is found here:

```
 include/_DEVELOPMENT/sdcc/stdio.h
```

Note that that file is under the sdcc/ subdirectory, so it's picked up by our
zsdcc compilation, but it isn't in the zx/ subdirectory. Instead it's in the
sdcc root includes directory, along with all the other generic headers. We're
only interested in Spectrum development in this guide, but in fact this file is
the standard header file for any Z88DK target which uses the standard IO
library.

### ROM Dump

stdio brings to the Spectrum a lot of things, including the printf() function
found on much more powerful machines. Here's an example which hexdumps the first
few bytes of the Spectrum's ROM:


```
  /* C source start */

  #include <arch/zx.h>
  #include <stdio.h>

  int main()
  {
    unsigned char* rom_addr = 0;
    unsigned char i, j;

    zx_cls(PAPER_WHITE);

    for( i=0; i<20; i++ )
    {
      printf("0x%04X: ", rom_addr);

      for( j=0; j<8; j++ )
      {
        printf("%02X ", *(rom_addr+j));
      }
      printf("   ");
      for( j=0; j<8; j++ )
      {
        printf("%c ",
               (*rom_addr>=32 && *rom_addr<=127) ? *rom_addr : '.');
        rom_addr++;
      }

      printf("\n");
    }
  
    return 0;
  }

  /* C source end */
```

Save it to a file called rom_in_hex.c and compile it with this compile command:


```
zcc +zx -vn -startup=4 -clib=sdcc_iy rom_in_hex.c -o rom_in_hex -create-app
```

Did you spot the -startup=4 argument? This chooses crt4. Z88DK's C runtime 4
sets up the Spectrum's screen in 64 column mode. Try changing the outer loop to
run 50 times instead of 20. This allows you to see Z88DK's stdio pagination at
work.

### Standard Input

We've covered the output part of standard IO, so let's have a look at the
input. Hopefully anyone familiar with stdio on any other type of machine should
already be able to see how this is going to work. Here's a small code file
called question.c:

```
  /* C source start */

  #include <arch/zx.h>
  #include <stdio.h>

  int main()
  {
    unsigned char name[15];

    zx_cls(PAPER_WHITE);

    printf("What is your name? ");
    gets(name);  /* Dangerous! See below */
    printf("Hello, %s", name);

    return 0;
  }

  /* C source end */
```

We'll go back to 32 column mode for this one (crt0), so the compile command is:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy question.c -o question -create-app
```

Note that with stdio comes the same responsibilities usually associated with the
library on other platforms. This includes avoiding things like buffer
overflows. The example above uses a buffer of 15 bytes for the entered name. Try
entering a 20 character string and see how the Spectrum behaves. The use of
gets() is discouraged for this reason. The better alternative is this one:

```
  fgets(name, 15, stdin)
```

The Z88DK stdio library includes all the other things you'd expect from stdio,
so you get sprintf(), scanf(), etc. Read the header file and experiment.


## Embedded Control Codes

So far this example has used simple strings for its stdio output, enabled using
crt0 via the -startup=0 compile time option. The Z88DK stdio package has a more
advanced feature, that of "control codes" embedded within the string to be
printed. Control codes are non-ASCII values which wouldn't normally make sense
to try to print, but if you embed them in the output string Z88DK's stdio
package will spot them and use them to control the way the output is presented
on screen. For example, you can use control codes to change the screen position
to print at, or the INK colour to be used.

Control codes are ready to use in several of the crts. crt0, which we've used so
far in this example, doesn't have them. crt1 is similiar to crt0 but has the
control code handling enabled.

Change the print line in your hello_world.c program to this:

```
  puts("Hello, \x10\x33world!");
```

and recompile with crt1 using:

```
zcc +zx -vn -startup=1 -clib=sdcc_iy hello_world.c -o hello_world -create-app
```

When you run this program you'll see the word "world" is in magenta ink. Why?
Because control code '\x10' (hex, that's 16 decimal) is the one which selects
the ink colour, and it takes the next byte in the string as the colour to
use. '\x33' is the character '3', and 3 on the Spectrum is magenta.

Note that it's '\x33' not '\x03'. The value is offset by 30 hex. Why? Because
otherwise black would be '\x00' which is the null terminator, and would mean the
end of the string! Black in control code terms is '\x30'. (If you find yourself
having to output a control code of '\x00' you can use the putc() function to do
it.)

Try this one:

```
  puts("\x16\x0A\x0C\x12\x31Hello\x12\x30, world!");
```

Code '\x16' (hex, that's 22 decimal) is the 'AT' control which sets the cursor
position. The next 2 bytes provide the x,y cursor character location (0A,0C hex
is 10,12 decimal). Note that the stdio code takes the arguments in x,y order,
which is the opposite way round to Spectrum BASIC's AT operator, and that
coordinates are 1-based, not 0-based. That is, the top left corner of the screen
is 1,1, not 0,0.

Code '\x12' (hex, that's 18 decimal) is the 'FLASH' one, and the next byte,
'\x31', is '1', so it switches on flash. Just after the "Hello" the flash is
switched off again.

Control codes don't exactly make for easy reading in the code, but they're a
very efficient way of getting control over text if that's what your program
requires. Macros can make them more readable. For example:

```
  #define FLASH_ON "\x12\x31"
```

A subtle caveat to look out for. Consider this:

```
  puts("\x16\x0A\x0BCool!");
```

So that's move to location 10,11 and print "Cool!". Only it isn't, because hex
strings are consumed by the compiler in a greedy manner. That string would print
"ool!" at location 10,188 because '\x0BC' is 188 decimal. Use C's string
concatenation to work around this:

```
  puts("\x16\x0A\x0B" "Cool!");
```

Documentation for control codes, as implemented by the new Z88DK libraries,
hasn't been completed yet. Reading the source files is the only way to get
definitive documentation. They're [here](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/target/zx/driver/terminal/zx_01_output_char_32_tty_z88dk):

```
  libsrc/_DEVELOPMENT/target/zx/driver/terminal/zx_01_output_char_32_tty_z88dk
```

The filenames of the files in that source tree indicate what codes do what.

### CRTs, for reference

So far in this guide we've looked at the following C runtimes. It's always worth
checking to ensure you're using the right one. If you don't need control codes
don't use one of the crts which enable them. You'll save memory.

#### -startup=0 (crt0)

32x24 mode, no control code support

#### -startup=1 (crt1)

32x24 mode, control codes supported

#### -startup=4 (crt4)

64x24 mode, no control code support

#### -startup=5 (crt5)

64x24 mode, control codes supported

#### -startup=31 (crt31)

stdio not supported at all

### And a couple more CRTs we didn't look at:

#### -startup=8 (crt8)

fzx proportional fonts, no control code support

#### -startup=9 (crt9)

fzx proportional fonts, control codes supported

#### -startup=30 (crt30)

32x24 rom print routine, no scanf
much smaller than other crts because the rom is used for output

[... continue to Part 3: Simple Graphics](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_03_SimpleGraphics.md)
