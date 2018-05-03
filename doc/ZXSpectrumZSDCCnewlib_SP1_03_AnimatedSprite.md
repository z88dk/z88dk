# ZX Spectrum Development with C, Z88DK and SP1 - Animated Sprite

This document describes how a ZX Spectrum developer can use the SP1 sprite
library to animate a sprite on screen. It follows on from the [second
document](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_02_SimpleMaskedSprite.md)
in the series, which the reader is assumed to have read.

This document is part of the [ZX Spectrum Z88DK/C developer's getting
started guide](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_GettingStartedGuide.md).

## Purpose


### The Sprite Data

For this article we're going stay with the same sort of 8x8 pixel, single column
sprites we've used so far in the series. The animated sprite we're going to use
is a little "runner" character kindly supplied by
[Sol_HSA](https://www.worldofspectrum.org/forums/profile/10193/Sol_HSA) over at
World of Spectrum. Here it is as an animated GIF file:

![alt text](images/runner32.gif "Runner sprite")

As in previous examples, we code this graphics data as an assembly listing:

```
SECTION rodata_user

PUBLIC _runner

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000

._runner
._runner_f1
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00010000
	defb @00010000
	defb @00000000
	defb @00100000
	defb @00011000

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	
._runner_f2
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00100000
	defb @00100000
	defb @00000010
	defb @00000100
	defb @00110000

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	
._runner_f3
	defb @00000000
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00100000
	defb @01000000
	defb @00000000
	defb @01100110

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	
._runner_f4
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00010000
	defb @00100000
	defb @00000000
	defb @01000000
	defb @01001100

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	
._runner_f5
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00001000
	defb @00010000
	defb @00000000
	defb @00100000
	defb @00011000

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
		
._runner_f6
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00001000
	defb @00001000
	defb @00000010
	defb @00000100
	defb @00110000

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
		
._runner_f7
	defb @00000000
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00001000
	defb @00000100
	defb @00000000
	defb @01100110

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
		
._runner_f8
	defb @00011000
	defb @00011110
	defb @00000000
	defb @00010000
	defb @00001000
	defb @00000000
	defb @01000000
	defb @01001100

	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
	defb @00000000
```

The first thing to note about this data is that it was typed in by your author,
by hand. The animated GIF was loaded into a graphics editor where the frames
where examined and the binary data carefully copied, bit by bit, into the
listing above. As of this writing there doesn't appear to be any magic tool to
create SP1 sprite data assembly listings from an animated GIF.

Secondly, there is no mask data in this listing, for no reason other than your
author didn't want to have to type those data lines in as well. We're going to
go back to using SP1's LOAD draw routines which we used in [article
1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#a-closer-look-at-the-sprites-code).

What we have here is an 8 frame sprite. That is, 8 separate 8x8 pixel graphics,
which run together create the animation. Frame 8 is designed to loop back to
frame 1, and each frame is designed to move the character one pixel left to
right to produce a walking effect.

The individual frames are labelled in the listing, but only for information
purposes. These labels are not exported since the C code doesn't need them for
this example.

Notice how each frame is separated from the next with 8 zero bytes. As discussed
in the [first
article](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md#pixel-positioning)
in this series, each sprite needs to have 7 zero bytes *before* it in memory,
and 8 zero bytes *after* it, in order to facilitate precise pixel
positioning. This requirement persists for individual sprite animation frames,
and when sprite frames are positioned sequentially in memory, as they are here,
it's convenient to use the same 8 zero bytes as the *after* bytes for one frame
and the *before* bytes for the following frame. This technique saves 8 bytes per
frame.

Finally, take note that given this layout each frame is located 16 bytes higher
in memory than the previous one. For example, label *runner_f2* will assemble to
be 16 greater than label *runner_f1*, those being the 8 bytes of data for frame
1, plus the 8 bytes of zeros which separate frame 1 from frame 2. This is
important because this value of *16 bytes* becomes a sort of magic number when
we get to the code in a moment.

Save this listing to a file called *runner_sprite.asm*.

## Animating the sprite

Here's the code to draw the sprite. Save it to a file called 'runner.c':

```
```

The compile line is:

```
```


## Conclusion


### Where To Go From Here

