## ZX SPECTRUM SP1 SPRITE ENGINE

SP1 has been around in one form another for at least 15 years and in that time around 30-40 games have been written for it or its predecessor SPLIB2.  Some recent games include [Ninjajar](http://www.mojontwins.com/juegos_mojonos/ninjajar/), [Forest Raider Cherry](http://www.worldofspectrum.org/infoseekid.cgi?id=0025408) and [Sgt Helmet Zero](http://www.mojontwins.com/juegos_mojonos/sgt-helmet-zero/). 

It is a sophisticated engine that is not completely documented, however if you are familiar with how many game consoles worked in the mid 1980s with their background tiles and sprites, SP1 works in a similar manner.

* [Brief Overview of the Engine](https://www.z88dk.org/wiki/doku.php?id=library:sprites:sp1)
* [Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/sp1.h)
* [Largely Up-to-Date Commentary](https://www.z88dk.org/wiki/doku.php?id=libnew:examples:sp1_ex1) SP1 configuration is now done through z88dk/libsrc/_DEVELOPMENT/target/zx/config_sp1.m4
* [Set of Old Tutorial Programs](https://github.com/z88dk/z88dk/tree/master/libsrc/sprites/software/sp1/spectrum/examples) showing how part of the SP1 library works.  I am a little hesitant to link these because Z88DK has been simplified since then so these programs will not compile as-is.  Changes concern how SP1 allocates memory (it is now implied to be through malloc/free) and how data is defined in asm (it should be done in a separate .asm file).  The ideas and API calls are the same so seeing these examples and reading the comments in the .c source should be of value to understand how things work.
