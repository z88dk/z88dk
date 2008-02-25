
// SOFTWARE SPRITE ENGINE
// SP1 - Z88DK Sprite Package #1

Sprite Pack v3.0
(c) 2002-2008 aralbrec
z88dk license applies

// DOCUMENTATION

See the z88dk wiki at http://www.z88dk.org/
Documentation is still scant there but will
hopefully fill out with time.

Some examples can be found in the {target}/examples
directories.

// PORTING TO OTHER MACHINES

Several ports are underway.  As of now three versions
of the library are available:

1. spectrum  (256x192 pixel, 32x192 colour resolution)
2. ts2068hr  (512x192 pixel monochrome)
3. zx81hr    (256x192 pixel monochrome)

These ports can be used as the basis for other targets
having similar screen resolutions.

ts2068hr is suitable for any black and white target with
memory mapped display.

spectrum is suitable for targets with pixel displays
having character-size colour overlays.

If the new target's screen resolution matches one of the
descriptions above, porting can be as simple as customizing
two or three assembler functions.

// COMPILING THE LIBRARY

The library is compiled from the {z88dk}/libsrc
directory.

Only one version of the SP1 library can exist at a
time.

Before building the library you can customize several
library parameters such as size of the display file
managed, memory map, etc by editing the file
"customize.asm" inside the target directory.  The
default configuration, which "customize.asm" initially
contains, is also held in the file
"{target}-customize.asm".

After building the library the header file "sp1.h"
will be created in the {z88dk}/include/sprites directory
so that C programs can include it with
"#include <sprites/sp1.h>".

The customized sp1 library "sp1.lib" will be created in
the {z88dk}/libsrc directory as is done with all libraries.
Move it to the correct final location with a "make install"
from the {z88dk}/libsrc directory.  Link to the sp1 library
on the compile line with "-lsp1".

- aralbrec 02.2008
