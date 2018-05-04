Windows and MacOSX users can get zsdcc and zsdcpp binaries from the [nightly build](http://nightly.z88dk.org/).

To build from source apply the patch in this directory to sdcc #9958.
Compile instructions can be found [here](https://www.z88dk.org/wiki/doku.php?id=temp:front#sdcc1).

For an error-free compile you may want to limit the target cpus in the build to just the z80 family 
(z80/z180/rabbits).  [z88dk.Dockerfile](https://github.com/z88dk/z88dk/blob/master/z88dk.Dockerfile)
can provide such hints for compiling the zsdcc source.

An alternative course is to use [docker](https://github.com/z88dk/z88dk/blob/master/doc/Dockerfile.md)
to install z88dk.
