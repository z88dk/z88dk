## Instructions

Windows and MacOSX users can get zsdcc and zsdcpp binaries from the [nightly build](http://nightly.z88dk.org/).

For Linux users follow the instructions on the [installation page](https://github.com/z88dk/z88dk/wiki/installation) and sdcc will be built for you.

### Patch Information

`sdcc-z88dk.patch` is the current default standard patch.

`sdcc-13131-backport-z88dk.patch` is the current zsdcc patch, retained for comparison and building against sdcc 4.2.0 r13131.

`sdcc-9958-z88dk.patch` is the previous z88dk v1.99c zsdcc standard patch, retained for comparison and building against sdcc r9958.

`sdcc-9958-remnants-z88dk.patch` is the sections of the `sdcc-9958-z88dk.patch` file not directly included in sdcc mainline or in the current default standard patch.  The changes relate to the z80 peephole optimiser. This file is retained for the record.

`sdcc-10892-remnants-z88dk.patch` was submitted as sdcc [feature request # 289](https://sourceforge.net/p/sdcc/patches/289/) for review, test, and integration from that end. The changes relate to the z80 peephole optimiser. This file is retained for the record.

Essentially, the current default standard patch items remaining are just those things which are zsdcc specific, which don't make sense to push into sdcc.
