
===============
BeepFX by Shiru
===============

This is a Windows tool that could be used to create beeper sound
effects for ZX Spectrum.

The effects are defined by small set of parameters and stored in
a compact way, with the player code size a bit larger than 200
bytes. Sound effects could be then compiled into binary or saved
as an assembly source, to be used in BASIC or machine code programs.

Besides the generated sound effects, there is 1-bit sample support
with built-in WAV files converter. This could be used for short
voice clips or more realistic sounds.

There is a demo project demo.spj provided along with the program,
containing many sound effects. If you can't design your own effects,
you can just use some of these.

This software is provided under the terms of the WTFPL v2 license.
You are free to use it without any limitations, without any warranty.



You can create a bank that contains up to 128 sound effects. Every
effect can contain up to 128 blocks of few kinds.

There are four kinds of blocks:

- Tone. It has parameters of duration, pitch, duty cycle, pitch and
duty cycle slide. The duration is measured in frames and frame length.
Slide values are only applied once per frame.

- Noise. It has parameters of duration, pitch and pitch slide. Noise
pitch has much lower resolution than tone.

- Sample. You can import up to 128 samples, if they'll fit into the
RAM, and use them in many sound effects as a block, with parameters
of start offset and pitch. This approach allows to reuse the same
sample in different effects with different settings without duplicating
sample data in memory.

- Pause. It just creates silence of specified duration in case when
you need to separate blocks.



The sound effects player uses contents of the BASIC ROM to generate
noise. The editor uses random numbers instead of actual ROM content,
which sounds well enough, but if you want to have better accuracy,
you can place 48.rom file into the folder with the editor.



To use effects in BASIC, compile them at some high address, like 60000.
Load the code block, POKE the address+1 with effect number 0...N, but not
higher than actual number of effects, then call the effect with RANDOMIZE
USR. For example:

POKE 60001,0:RANDOMIZE USR 60000



This program uses WTFpl'ed Z80 CPU emulation engine by Ketmar.



Versions:

v1.11 20.09.12 - Assembly output is more compatible with assemblers other than SjAsmPlus
v1.1  31.07.12 - Sample support, Z80 emulation core is replaced
v1.02 05.12.11 - PlaySound replaced with WaveOut player to fix audio problems in Windows 7
v1.01 04.12.11 - Minor fixes, Merge project function
v1.0  03.12.11 - First release

http://shiru.untergrund.net


===========
Z88DK NOTES
===========

The sound effects included with the editor have been added to the library and can be
played by name.  Only data from sound effects referred to in the program will be added
to the binary.

Other changes:

* use one index register for compatibility with all targets
* eliminated self-modifying code
* modified for any sound output method
* delay loops introduced for fast cpus (target cpu freq is 3.5 MHz)
