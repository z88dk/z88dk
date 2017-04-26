# ZX SPECTRUM NIRVANA+ DEMO
[Game Engine Author's Website](https://www.ime.usp.br/~einar/bifrost/)  
[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/arch/zx/nirvanap)  
[Plain Header File in Z88DK](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/arch/zx/nirvana%2B.h)

Some games using Nirvana+ not listed on the author's website:  Pietro Bros, Snake

Before using Nirvana+, it should be configured.

The default configuration is:

 * Spectrum 48/128 mode
 * Disable wide draw and wide sprites
 * Total rows = 23

This program assumes the default configuration so nothing needs to be done to configure the engine prior to compiling.

## Nirvana- Configuration

However in other circumstances, the nirvana+ target configuration file should be edited to change the settings
("z88dk/libsrc/_DEVELOPMENT/target/zx/config_nirvanap.m4") and then the zx library should be rebuilt by running:

`Winmake zx` (windows)  
`make TARGET=zx` (other)

from the "z88dk/libsrc/_DEVELOPMENT" directory.

Note that if wide tiles or wide sprites are enabled, the ORG address of the Nirvana+ engine will change from 56323.  You can find the correct ORG address by compiling with the "-m" flag to generate a map file and then look up "org_nirvanap" in that file to find its value.  Because this program uses the default configuration, the appmake invocation to generate the nirvana+ tap assumes an ORG of 56323.

## Compile the Demo

This program can be compiled as follows:

1. SCCZ80 + New C Library
```
zcc +zx -vn -startup=1 -clib=new nirvanadem.c btile.asm -o nirvanadem
appmake +zx -b nirvanadem_NIRVANAP.bin -o nirvanap.tap --noloader --org 56323 --blockname NIRVANAP
appmake +zx -b nirvanadem_CODE.bin -o nirvanadem.tap --noloader --org 32768 --blockname nirvanadem
copy /b loader.tap + nirvanap.tap + nirvanadem.tap demo.tap
```
2. ZSDCC + New C Library
```
zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 nirvanadem.c btile.asm -o nirvanadem
appmake +zx -b nirvanadem_NIRVANAP.bin -o nirvanap.tap --noloader --org 56323 --blockname NIRVANAP
appmake +zx -b nirvanadem_CODE.bin -o nirvanadem.tap --noloader --org 32768 --blockname nirvanadem
copy /b loader.tap + nirvanap.tap + nirvanadem.tap demo.tap
```
After compiling, the binaries "nirvanadem_CODE.bin" (containing the program) and "nirvanadem_NIRVANAP.bin" (containing the nirvana+ engine) are produced.

Appmake is run to turn those into CODE-only tap files.

Windows "copy" is used to append those taps to the end of "loader.tap" to form the final tap file "demo.tap"

"loader.tap" contains this basic loader:

```
10 CLEAR VAL "32767"
20 LOAD "NIRVANAP"CODE
30 LOAD ""CODE
40 RANDOMIZE USR VAL "32768"
```
