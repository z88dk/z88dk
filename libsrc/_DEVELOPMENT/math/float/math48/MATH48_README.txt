
"MATH48_MANUAL.txt" contains the original source code and manual for the math48 float package.

===============================================================

Key features of the math48 float package:

* Written in assembly language.

* All code is re-entrant; the package does not use any static data.

* The floating point accumulator and operand are held in registers rather than in memory.

* The float format has a 40-bit mantissa and 8-bit exponent with 128 bias.

* Register use is limited to the main set, the exx set and one index register (ix by default).

===============================================================

The directory structure is as follows:

* primitives

Contains the original math48 functions implementing the core of the float package.  Two changes have been made to the source:

1- The primary floating point accumulator is now in the exchange set and the secondary floating point accumulator is in the main register set.  This is exactly opposite of the original math48 package.  Doing things this way makes interfacing with the C compiler much simpler.

2- Errno is properly set when floating point errors occur.

* c_standard

Contains the math functions expected by the C11 standard.  These are implemented in terms of the math48 primitives and make up the assembly language interface to the library.

* c_interface

Contains the c compiler interface that calls into the assembly language implementation in the c_standard directory.  Float conversion between the math48 format and the format expected by the compilers is done here.

* lm

Glue that connects the compilers to the math48 library.  These functions make up the math library that is linked against on the compile line (as in "-lm").

===============================================================

Thanks to Thorleif Bundgaard (see "MATH48_MANUAL.txt") for preserving this math package on the internet and for translating the documentation to make it so easy to use.

Thanks to Anders Hejlsberg for writing the package in the first place.  The idea of using BCDEHL and BCDEHL' as floating point accumulators was a good one.  Who knew your work would find application 35 years later?

We hope to contact Anders to gain his permission to use this math package in z88dk.
