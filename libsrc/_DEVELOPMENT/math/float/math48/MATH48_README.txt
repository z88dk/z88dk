
"MATH48_MANUAL.txt" contains the original source code and manual for the math48 float package.

===============================================================

Key features of the math48 float package:

* Written in assembly language.

* All code is re-entrant; the package does not use any static data.

* The floating point accumulator and operand are held in registers rather than in memory.

* The float format has a 40-bit mantissa and 8-bit exponent with 128 bias.

* Register use is limited to the main set, the exx set (incl af') and one index register (ix by default).

===============================================================

The directory structure is as follows:

* z80/core

Contains the original math48 functions implementing the core of the float package.  Two changes have been made to the source:

1- The primary floating point accumulator is now in the exchange set and the secondary floating point accumulator is in the main register set.  This is exactly opposite to the original math48 package.  Doing things this way makes interfacing with the C compiler much simpler.

2- Errno is properly set when floating point errors occur.

A few core functions have been added.

* z80

Contains the assembly language interface to the math library.  This includes the math functions expected by the C11 standard and various low level functions necessary to implement a complete float package accessible from assembly language.  These functions are implemented in terms of the core math48 functions.

* c/sccz80

Contains sccz80's C compiler interface and is implemented using the assembly language interface in the z80 directory.  Float conversion between the math48 format and the format expected by sccz80 occurs here.

* lm

Glue that connects the compilers and standard assembly interface to the math48 library.  The purpose is to define aliases that connect the standard names to the math48 specific names.  These functions make up the math library that is linked against on the compile line (as in "-lm").

===============================================================

Thanks to Thorleif Bundgaard (see "MATH48_MANUAL.txt") for preserving this math package on the internet and for translating the documentation to make it so easy to use.

Thanks to Anders Hejlsberg for writing the package in the first place.  The idea of using BCDEHL and BCDEHL' as floating point accumulators was a good one.  Who knew your work would find application 35 years later?

We hope to contact Anders to gain his permission to use this math package in z88dk.
