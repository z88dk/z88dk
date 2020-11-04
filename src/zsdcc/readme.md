## Instructions

Windows and MacOSX users can get zsdcc and zsdcpp binaries from the [nightly build](http://nightly.z88dk.org/).

For Linux users follow the instructions on the [installation page](https://github.com/z88dk/z88dk/wiki/installation) and sdcc will be built for you.

### Patch Information

`sdcc-z88dk.patch` is the current default standard patch.

`sdcc-11940-z88dk.patch` is the current zsdcc patch, retained for comparison and building against sdcc r11940.

`sdcc-9958-z88dk.patch` is the previous z88dk v1.99c zsdcc standard patch, retained for comparison and building against sdcc r9958.

`sdcc-10892-z88dk-peep.patch` has been submitted as sdcc [feature request # 289](https://sourceforge.net/p/sdcc/patches/289/) for review, test, and integrate from that end. This file is retained for the record.

Essentially, the patch items remaining are just those things which are zsdcc specific, which don't make sense to push into sdcc.
