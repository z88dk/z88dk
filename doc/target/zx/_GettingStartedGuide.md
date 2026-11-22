# The ZX Spectrum Programmer's Z88DK Getting Started Guide

The *ZX Spectrum Programmer's Z88DK Getting Started Guide* consists of a series of documents written to assist Spectrum developers who want to write programs in 'C' using the Z88DK development toolset. The reader is expected to know the 'C' programming language, but otherwise the series starts from the very beginning.

The articles lean towards Spectrum games development, and they are designed to be read in sequence:

| Article               | Covers                                                   |
| --------------------- | -------------------------------------------------------- |
| [Getting Started][01] | The Z88DK toolset, compiler command line                 |
| [Hello World][02]     | Text, stdio, CRTs                                        |
| [Simple Graphics][03] | Simple graphics, screen addressing, line drawing example |
| [Input Devices][04]   | Keyboard, scancodes, joysticks                           |
| [Multiple Files][05]  | Multiple file builds, list files                         |
| [Some Details][06]    | Memory map, pragmas                                      |
| [BiFrost][07]         | The BiFrost multicolour library                          |
| [Interrupts][08]      | Z80 Mode 2 interrupts                                    |

[01]: 01_GettingStarted.md
[02]: 02_HelloWorld.md
[03]: 03_SimpleGraphics.md
[04]: 04_InputDevices.md
[05]: 05_MultipleFiles.md
[06]: 06_SomeDetails.md
[07]: 07_BiFrost.md
[08]: 08_Interrupts.md

A complementary series of documents covers the SP1 sprite library, which is an excellent basis for Spectrum games written with Z88DK:

| Article                         | Covers                               |
| ------------------------------- | ------------------------------------ |
| [SP1, Getting Started][S01]     | Getting started with SP1             |
| [SP1, Masked Sprites][S02]      | Masked sprites                       |
| [SP1, Animated Sprites][S03]    | Animated sprites                     |
| [SP1, Bigger Sprites][S04]      | Bigger sprites, colour               |
| [SP1, Collision Detection][S05] | Detecting collisions between sprites |

[S01]: SP1_01_GettingStarted.md
[S02]: SP1_02_SimpleMaskedSprite.md
[S03]: SP1_03_AnimatedSprite.md
[S04]: SP1_04_BiggerSprites.md
[S05]: SP1_05_CollisionDetection.md

These documents are a work in progress. Comments and suggestions are welcome in the [Z88DK Sinclair ZX forum](https://www.z88dk.org/forum/viewforum.php?f=2).

## Further Reading

* [The author's Github project](https://github.com/derekfountain/z88dk-zxspectrum-examples) - Example code from this guide with pre-compiled TAP files and occasionally some further work and extensions.
* [Wonky One Key](https://github.com/derekfountain/zxwonkyonekey) - An SP1-based game written by the author of this guide, uses lots of the techniques covered.
* [The Virus](https://github.com/derekfountain/the-virus) - Another game written by the author of this guide.
* [Jordi Sesmero's SP1 Tutorial](https://github.com/jsmolina/z88dk-tutorial-sp1) - Another tutorial on using the SP1 library, covers more topics than this guide albeit in less detail. Contains a nice [Pacman](https://spectrumcomputing.co.uk/forums/viewtopic.php?p=30569) example.
* [Antonio Mateus's SP1 Examples](https://github.com/antoniocmateus) - A selection of SP1 examples, including a nice [Breakout clone](https://github.com/antoniocmateus/z88dk_sp1_breakout) which uses tiles.

And of course, the [Programming Forum](https://spectrumcomputing.co.uk/forums/viewforum.php?f=6) at [Spectrum Computing](https://spectrumcomputing.co.uk/), where many of the best Spectrum developers are always ready to discuss everything to do with programming the ZX Spectrum.

[Derek Fountain](http://www.derekfountain.org/), October, 2024
