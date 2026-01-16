# ZX SPECTRUM NIRVANA+ DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/target/zx/nirvanap)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/nirvana%2B.h)

Some games using Nirvana+ not listed on the author's website:  Pietro Bros, Snake

Before using Nirvana+, it should be configured.

The default configuration is:

 * Spectrum 48/128 mode
 * Disable wide draw and wide sprites
 * Total rows = 23

This program assumes the default configuration so nothing needs to be done to configure the engine prior to compiling.

## Compile the Demo

This program can be compiled using the makefile.

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
20 LOAD "NIRVANAP"CODE
30 LOAD ""CODE
40 RANDOMIZE USR VAL "32768"
```
