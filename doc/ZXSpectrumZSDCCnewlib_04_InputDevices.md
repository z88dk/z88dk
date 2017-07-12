# ZX Spectrum Development with Z88DK - Input Devices

This is the fourth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from
[installment 3](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_03_SimpleGraphics.md).  If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Input Devices

We looked at stdio in the second part of this series, and established that
that's the library to use if you want to print a prompt and have the user type
something in. But that's not what's required for other types of applications,
especially games, where the approach is much more fluid: for a game you'd want
to read the keyboard, see which keys are being held down (if any), then
immediately move on to have your program respond to them. Ditto for joysticks.

This type of interaction with input devices is supported in Z88DK using the
_input_ library.

## The Input Library

The input library header file is [here](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/input.h):

```
include/_DEVELOPMENT/sdcc/input.h
```

and a quick skim read of that file will show that when you're writing for the
ZX Spectrum it #include's the [Spectrum specific file](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/input/input_zx.h):

```
include/_DEVELOPMENT/sdcc/input/input_zx.h
```

There isn't a great deal in the way of documentation in the file, so a bit of
deduction and detective work is going to be required. However, it's worth
mentioning that the assembly language routines which implement these functions
_do_ carry descriptions of what they do. See the ASM files [here](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/input/zx/z80):

```
libsrc/_DEVELOPMENT/input/zx/z80
```

## Simple key presses - Interactive Border Example

As before, we start with something simple and get it compiling. Here's something
simple:

```
/* C source start */

#include <arch/zx.h>
#include <input.h>

int main()
{

  while( 1 )
  {
    zx_border(INK_WHITE);

    in_wait_key();

    zx_border(INK_BLUE);

    in_wait_nokey();
  }
}

/* C source end */
```

Compile this with what should now be becoming our familiar compile line:

```
zcc +zx -vn -startup=31 -clib=sdcc_iy key_press.c -o key_press -create-app
```

We use the new library (sdcc_iy) and crt number "31", which you'll recall is the
one which doesn't set up a terminal driver. We don't need it for this example.

This program uses the zx_border() library routine we've seen before to change
the border colour, then calls the input library function which sits and waits
for a key to be pressed. Any key will do including the shift keys; the key which
is pressed isn't returned. When a key is pressed the border is turned blue, then,
since we know at least one key is currently down, we call the input library
function which waits for _no_ key to be pressed. When the user releases the key
(strictly speaking, when they release _all_ keys they might be holding) the no-key
function returns and we go round the loop. Result: the border is white when the
keyboard is untouched, and turns blue when any key is being held down.

Let's see how to find which key is pressed. This time we'll use stdio to print
the information we're seeing from the keyboard:

```
/* C source start */

#include <stdio.h>
#include <input.h>

int main()
{
  unsigned char c;

  while( 1 )
  {
    in_wait_key();
    c = in_inkey();
    in_wait_nokey();

    printf("Key pressed is %c (0x%02X)\n", c, c);
  }
}

/* C source end */
```

This program needs stdio, so we have to compile with a C runtime which supports
it. crt0 will do nicely:

```
zcc +zx -vn -startup=0 -clib=sdcc_iy key_value.c -o key_value -create-app
```

The in_inkey() function examines the keyboard and immediately returns a code
relating to the key being pressed. So in this case we wait for a key to be
pressed using in_wait_key(), then read the key using in_inkey(), then wait for
the key to be released using in_wait_nokey() before showing the result.

For normal keys the in_inkey() function returns the ASCII code of the key being
pressed.  If no keys are pressed, it returns 0.  If more than one key is pressed
it also returns 0.  The shift keys, if pressed on their own, do not register and
also cause in_inkey() to return 0.  However, if the shift keys are pressed in
combination with regular keys, the shifted ascii value will be returned.

These limitations mean in_inkey() is only useful in certain situations. For an
accurate picture of what's happening on the keyboard we need to turn to _scancodes_.

## Scancodes

For faster and more accurate information on what's happening on the keyboard we
need to switch to examining _scancodes_. A scancode is a single number which
represents the physical state of the keyboard when a single character is
entered. Each scancode is a 16 bit, predefined and hardcoded number, and some of
the common ones are listed in input_zx.h, like this:

```
#define IN_KEY_SCANCODE_a      0x01fd
#define IN_KEY_SCANCODE_b      0x107f
#define IN_KEY_SCANCODE_c      0x08fe
#define IN_KEY_SCANCODE_d      0x04fd
...
```

You might reasonably ask what the point is. After all, 65 is a unique number and
since that's the ASCII code for 'A', why not use that instead of 0x01FD? The
answer is _speed_. The scancodes directly reflect the values returned by the
hardware when the keyboard is scanned. Why the scancode numbers are what they
are is tied into the layout of the keyboard matrix and is irrelevant to the
programmer. The important point is that the keyboard hardware can be examined
and checked to see if it matches a given scancode very quickly. That is what the
in_key_pressed(uint16_t) function does: you give it a scancode and it returns a
value indicating whether the corresponding key is currently up or down. Here's
an example which reads 5 keys and shows the results:

```
/* C source start */

#include <stdio.h>
#include <input.h>
#include <arch/zx.h>

int main()
{
  zx_cls(PAPER_WHITE);
  while( 1 ) {

    printf("\x16\x01\x01");

    printf("Scan for q returns 0x%04X\n",   in_key_pressed( IN_KEY_SCANCODE_q ));
    printf("Scan for a returns 0x%04X\n",   in_key_pressed( IN_KEY_SCANCODE_a ));
    printf("Scan for o returns 0x%04X\n",   in_key_pressed( IN_KEY_SCANCODE_o ));
    printf("Scan for p returns 0x%04X\n",   in_key_pressed( IN_KEY_SCANCODE_p ));
    printf("Scan for <sp> returns 0x%04X\n\n", in_key_pressed( IN_KEY_SCANCODE_SPACE ));
  }
}

/* C source end */
```

This uses a control code to position the text so we need to compile it with a
control code supporting C runtime, such as crt1:

```
zcc +zx -vn -startup=1 -clib=sdcc_iy scancodes.c -o scancodes -create-app
```

You'll note that each call returns 0 if the key corresponding to the given
scancode is up, and -1 if it's held down. You'll also note that scancodes return
the expected results if multiple keys are pressed or held down
simultaneously. There's your walk-and-jump platformer game control.

An interesting aside: with some PC keyboards and an emulator this program
displays odd results if more than 3 keys are pressed, then held, in certain
sequences. This observation caused some puzzlement on the Z88DK user's mailing
list. It's due to limitations of modern PC keyboards. Real Spectrum hardware
doesn't exhibit the problem, and nor does the _ZX Spectrum Recreated_ device.

## Finding Scancodes with Shift

The list of scancodes in input_zx.h is handy for simple cases where you know in
advance which key you're looking for, but it doesn't list all the possible
permutations of keys, and doesn't handle cases where you're looking for shifted
key presses. For these cases you can programmatically find the appropriate
scancode. For example:

```
/* C source start */

#include <stdio.h>
#include <input.h>
#include <arch/zx.h>

int main()
{
  uint16_t dollar_scancode = in_key_scancode('$');

  zx_cls(PAPER_WHITE);
  while( 1 ) {

    printf("\x16\x01\x01");

    printf("Scancode for '$' is 0x%04X\n\n", dollar_scancode);
    printf("Scan for $ returns 0x%04X\n",   in_key_pressed( dollar_scancode ));
  }
}

/* C source end */
```

The in_key_scancode() function returns the 16 bit scancode value for the given
character, which in this case is the dollar symbol (symbol shifted '4'). The
scancode value for dollar is, apparently, 0x48F7, but that's of no real
interest, it's just a number. But once the program has that number it can be
used in the call to in_key_pressed(). The program only indicates the $ key is
pressed when both symbol shift and '4' are down.

## Building Scancodes

There are some scancode combinations which use the shift keys which you need to
build yourself. The top bit of a scancode value indicates the scancode should
yield true if the CAPS key is down, and the second top bit indicates the
scancode should yield true if the SYM key is down. So you can build your own
scancode for BREAK, which is CAPS+Space like this:

```
/* C source start */

#include <stdio.h>
#include <input.h>
#include <arch/zx.h>

int main()
{
  /* Space, plus top bit set means CAPS */
  uint16_t break_scancode = IN_KEY_SCANCODE_SPACE | 0x8000;

  zx_cls(PAPER_WHITE);
  while( 1 ) {

    printf("\x16\x01\x01");

    printf("Scan for <break> returns 0x%04X\n",  in_key_pressed( break_scancode ));
  }
}

/* C source end */
```

## Joysticks

The Z88DK input library supports a variety of joysticks, all in the same
way. You call the function appropriate to the user's selected joystick in order
to read the state of its stick and buttons. All the information is returned in a
single 16 bit word as a bit map.

Here's an example for my Kempston joystick (actually a PlayStation3 Gamepad
which Fuse is quite happy with):

```
/* C source start */

#include <stdio.h>
#include <input.h>
#include <arch/zx.h>

int main()
{
  uint16_t kempston_input;

  zx_cls(PAPER_WHITE);
  while( 1 ) {

    kempston_input = in_stick_kempston();

    printf("\x16\x01\x01");

    printf("Joystick input value is 0x%04X\n", kempston_input);
  }
}

/* C source end */
```

Compile with:

```
zcc +zx -vn -startup=1 -clib=sdcc_iy joy_input.c -o joy_input -create-app
```

This prints 0x0001 when the stick is moved up, 0x0002 when it's moved down,
0x0004 when it's moved left and 0x0008 when it's moved right. Those values are
defined as constants in the [input header file](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/input.h).

```
include/_DEVELOPMENT/sdcc/input.h
```

```
#define IN_STICK_FIRE    0x80
#define IN_STICK_FIRE_1  0x80
#define IN_STICK_FIRE_2  0x40
#define IN_STICK_FIRE_3  0x20

#define IN_STICK_UP      0x01
#define IN_STICK_DOWN    0x02
#define IN_STICK_LEFT    0x04
#define IN_STICK_RIGHT   0x08
```

Some joysticks have more than one fire button. My Kempston only has the one.

Moving the stick to one of the diagonal positions adds those values together,
so, for example, moving it to the up/right position gives the value 0x0009
(0x0001 for up plus 0x0008 for right). Holding fire adds 0x0080. For Kempston
the top byte of the uint16_t is not used.

All joysticks return the same format 16-bit value but may differ in the number
of fire buttons that can be detected.  The assembler files for these other
joysticks are well commented, and are
[here](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/input/zx/z80):

```
libsrc/_DEVELOPMENT/input/zx/z80/
```

Because the format of the return value from joystick functions are the same,
it possible to implement a user-defined joystick option using a function pointer
but this is beyond the scope of this introduction.

Also worth noting is that automatic joystick detection is not supported in
Z88DK's new libraries because doing so can be unreliable on certain Spectrum
models and clones. Attempting joystick detection is therefore not recommended.

Let's finish where we started, by playing with the border. Here's a program
which changes the border colour based on the joystick movements. Moving to the
diagonal positions and/or pressing fire makes the border swirl with colour.

```
/* C source start */

#include <input.h>
#include <arch/zx.h>

int main()
{
  uint16_t kempston_input;

  zx_cls(PAPER_WHITE);
  zx_border(INK_WHITE);
  while( 1 ) {

    kempston_input = in_stick_kempston();

    if( kempston_input & IN_STICK_UP )
      zx_border(INK_BLACK);

    if( kempston_input & IN_STICK_DOWN )
      zx_border(INK_BLUE);

    if( kempston_input & IN_STICK_LEFT )
      zx_border(INK_RED);

    if( kempston_input & IN_STICK_RIGHT )
      zx_border(INK_MAGENTA);

    if( kempston_input & IN_STICK_FIRE )
      zx_border(INK_GREEN);
  }
}

/* C source end */
```

Compile with:

```
zcc +zx -vn -startup=31 -clib=sdcc_iy joy_border.c -o joy_border -create-app
```

If your emulator does not map the kempston joystick to your controller or to
the keyboard, try using `in_stick_sinclair1()` in place of `in_stick_kempston()`.
The Sinclair sticks map themselves to the number keys on the keyboard.

### Where To Go From Here

[... continue to Part 5: Using multiple files](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_05_MultipleFiles.md)
