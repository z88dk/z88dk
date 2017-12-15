# ZX NEXT COPPER EXAMPLES

The ZX Next adds a copper unit which was inspired by the Amiga.  The copper unit is an independent device operating in parallel with the cpu whose timing is tied to the video generation.  It can either wait for a specific position on screen or modify the machine's state by writing to the NEXTREG registers.  What it does is determined by the program loaded into the copper unit on the fpga.  Z88DK/Z80ASM has added macros `cu.wait`, `cu.move`, `cu.nop` and `cu.stop` so that copper instructions can be generated in either asm or c code.  More information can be found [here](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/target/zxn/config/config_zxn_copper.m4).

As of writing with the Issue 2A boards now being delivered, the copper unit has not been tested thoroughly.  The examples here show how to use the copper unit in Z88DK but it's unknown whether the programs as written will actually work as intended.

## LAYER PRIORITY

This example places the ula in timex hi-res mode and creates two proportional font terminal windows on screen, into which a book is printed one line at a time.  The windows are scrolled one pixel at a time so the program can benefit from being sped up.  Holding "s" down until the scrolling stops will advance to the next speed in the sequence 3.5 MHz, 7 MHz and 14 MHz.

A simple layer 2 screen is scrolled on top.  A global transparency colour has been selected to allow some of the image to be seen through to see the underlying ula screen.

The copper unit is being used to dynamically change layer priorities while the screen is drawn so that the ula is placed on top of layer 2 where the ula text windows are drawn.  The result should be a layer 2 screen scrolling around the ula's timex hi-res text terminals.

The copper unit can only hold 512 instructions and there is no loop instruction so there is only space to do this for a few character rows.  However, if the test is successful the program will be modified to stream copper instructions in as needed to define the rectangular cutouts for the whole screen.
