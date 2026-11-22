# SPEECH BUBBLES

A program that demonstrates runtime configuration of a text terminal.
See the [helloworld](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/EXAMPLES/sms/helloworld) example first for necessary background information.

## Compiling

zsdcc (the high optimization setting can lead to long compile times):
~~~
zcc +sms -vn -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 speech.c quotes.c font_8x8_bubble.asm -o speech -pragma-include:zpragma.inc -create-app
~~~
sccz80:
~~~
zcc +sms -vn -startup=1 -clib=new -O3 speech.c quotes.c font_8x8_bubble.asm -o speech -pragma-include:zpragma.inc -create-app
~~~

ZCC can make a binary out of any number of .c, .asm, .s, .o, .m4 files on the compile line.  If listing all source files is tedious, they can be listed in a separate .lst file from which ZCC can read them.  In this example, two .c files and a single .asm file make up the program.

**speech.c**  
The main program.

**quotes.c**  
Holds Fawlty Towers quotes in a string array.

**font_8x8_bubble.asm**  
Contains a few 8x8 1-bit tiles defining the outline of a speech bubble.

## Description

In a loop, the program:

1. Decides on a random size and location for the speech bubble.
2. Saves the tiles currently found on the display at that location into memory.
3. Instructs the output terminal to resize and move to become the speech bubble.
4. Prints the speech bubble outline into the output terminal.
5. The output terminal is shrunk on all sides by one character so that it no longer covers the speech bubble outline.
6. A quote is randomly selected and printed into the output terminal.  The output terminal is configured to wait for a button press when the screen fills.
7. The output terminal is erased by restoring the tiles that were there.

The only thing new in this program is how options are communicated to the terminal driver via `ioctl()`.  Since the ioctl command constant names are verbose, what they do should be self-explanatory.  The code does make frequent use of the `IOCTL_OTERM_CLS` command, moreso than should be necessary.  The reason is this ioctl, besides clearing the terminal window, also resets the cursor coordinates to the top left corner and resets the scroll count (number of scrolls before the terminal pauses).
