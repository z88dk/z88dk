# The ZX Spectrum Programmer's Z88DK Getting Started Guide

The *ZX Spectrum Programmer's Z88DK Getting Started Guide* consists of a series
of documents written to assist Spectrum developers who want to write programs in
'C' using the Z88DK development toolset. The reader is expected to know the 'C'
programming language, but otherwise the series starts from the very beginning.

The articles lean towards Spectrum games development, and they are designed to
be read in sequence:


| Article         | Covers        |
| --------------- | ------------- |
| [Getting Started](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md) | The Z88DK toolset, compiler command line |
| [Hello World](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_02_HelloWorld.md)     | Text, stdio, CRTs |
| [Simple Graphics](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_03_SimpleGraphics.md) | Simple graphics, screen addressing, line drawing example |
| [Input Devices](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_04_InputDevices.md)   | Keyboard, scancodes, joysticks |
| [Multiple Files](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_05_MultipleFiles.md)  | Multiple file builds, list files |
| [Some Details](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_06_SomeDetails.md)    | Memory map, pragmas |
| [BiFrost](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_07_BiFrost.md)         | The BiFrost multicolour library |
| [Interrupts](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_08_Interrupts.md) | Z80 Mode 2 interrupts |

A complementary series of documents covers the SP1 sprite library, which is
an excellent basis for Spectrum games written with Z88DK:

| Article         | Covers        |
| --------------- | ------------- |
| [SP1, Getting Started](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_01_GettingStarted.md) | Getting started with SP1 |
| [SP1, Masked Sprites](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_02_SimpleMaskedSprite.md) | Masked sprites |
| [SP1, Animated Sprites](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_03_AnimatedSprite.md) | Animated sprites |
| [SP1, Bigger Sprites](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_04_BiggerSprites.md) | Bigger sprites, colour |
| [SP1, Collision Detection](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_SP1_05_CollisionDetection.md) | Detecting collisions between sprites |


These documents are a work in progress. Comments and suggestions are welcome in
the [Z88DK Sinclair ZX forum](https://www.z88dk.org/forum/viewforum.php?id=2).


| Further Reading | Covers        |
| --------------- | ------------- |
| [The author's Github project](https://github.com/derekfountain/z88dk-zxspectrum-examples) | Example code from this guide with pre-compiled TAP files and occasionally some further work and extensions. |
| [Wonky One Key](https://github.com/derekfountain/zxwonkyonekey) | A game written by the author of this guide, uses lots of the techniques covered. |
| [Jordi Sesmero's SP1 Tutorial](https://github.com/jsmolina/z88dk-tutorial-sp1) | Another tutorial on using the SP1 library, covers more topics than this guide albeit in less detail. Contains a nice [Pacman](https://spectrumcomputing.co.uk/forums/viewtopic.php?p=30569) example. |
| [Antonio Mateus's SP1 Examples](https://github.com/antoniocmateus) | A selection of SP1 examples, including a nice [Breakout clone](https://github.com/antoniocmateus/z88dk_sp1_breakout) which uses tiles. |

And of course, the [Programming Forum](https://spectrumcomputing.co.uk/forums/viewforum.php?f=6) at [Spectrum Computing](https://spectrumcomputing.co.uk/), where many of the best Spectrum developers are always ready to discuss everything to do with programming the ZX Spectrum.

[Derek Fountain](http://www.derekfountain.org/), March, 2021