## Instructions

Windows and MacOSX users can get zsdcc and zsdcpp binaries from the [nightly build](http://nightly.z88dk.org/).

To build from source apply the patch in this directory to sdcc r11214.
Compile instructions can be found [here](https://www.z88dk.org/wiki/doku.php?id=temp:front#sdcc1).

For an error-free compile you may want to limit the target cpus in the build to just the z80 family (z80/z180/rabbits).  [z88dk.Dockerfile](https://github.com/z88dk/z88dk/blob/master/z88dk.Dockerfile)
can provide such hints for compiling the zsdcc source. A configuration command provided for example.

```bash
./configure --disable-mcs51-port --disable-avr-port --disable-ds390-port --disable-hc08-port --disable-pic-port --disable-pic16-port --disable-xa51-port --disable-stm8-port --disable-tlcs90-port --disable-s08-port --disable-pic14-port --disable-ds390-port --disable-ds400-port --disable-ucsim --disable-device-lib --disable-packihx
```
An alternative course is to use [docker](https://github.com/z88dk/z88dk/blob/master/doc/Dockerfile.md)
to install z88dk.

### Patch Information

`sdcc-9958-z88dk.patch` is the previous zsdcc standard patch, retained for comparison and building against sdcc r9958.

`sdcc-10892-z88dk-peep.patch` has been submitted as sdcc [feature request # 289](https://sourceforge.net/p/sdcc/patches/289/) for review, test, and integrate from that end. This file is retained for the record. z88dk does not normally use the sdcc peephole optimiser, so these patches remain optional.

`sdcc-z88dk.patch` = `sdcc-9958-z88dk.patch` - previously committed additions and fixes to sdcc to support z88dk - `sdcc-10892-z88dk-peep.patch`.  Essentially, the patch items remaining are just those things which are zsdcc specific, which don't make sense to push into sdcc.
