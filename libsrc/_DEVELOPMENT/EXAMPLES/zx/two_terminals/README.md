# ZX SPECTRUM TWO SIMULTANEOUS TEXT TERMINALS

The Z88DK library is very sophisticated.  Its stdio model is a unix file i/o model with object oriented drivers.  One of the consequences of that is it is possible to create any number of terminal windows with varying characteristics including window sizes, fonts, scroll modes, and so on.  The object oriented nature of the implementation also means that you only pay for the terminal code once and then any number of additional terminals cost very little in terms of memory space because most of the code is shared.

In normal operation, the user communicates to Z88DK what he wants attached to stdin/stdout/stderr at startup with a `-startup=n` switch on the compile line.  By default, `-startup=0` is assumed if this parameter is absent.  A list of startups implemented for the spectrum target with a brief description can be found in [zx_crt.asm.m4](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/target/zx/zx_crt.asm.m4#L39) and the actual CRT implementation code corresponding to these startups can be found in the spectrum's [startup directory](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/target/zx/startup).  The most common startup used for games is `startup=31` which supplies a very minimal and lightweight CRT without any FILEs instantiated at all.

The key in this example is that Z88DK's CRTs allow the user to define his own set of drivers.  If the pragma "CRT_INCLUDE_DRIVER_INSTANTIATION" is set to a non-zero value then the CRTs will include the user-supplied file "crt_driver_instantiation.asm.m4" in their driver instantiation sections.  In other words, the user can instantiate any combination of drivers by supplying such a file.

In this example, an input driver is instantiated on fd=0 (stdin), and two different fzx window terminals are instantiated on fd=1 (window_1) and fd=2 (window_2).  You can see this instantiation in file "crt_driver_instantiation.asm.m4" and the results by running the program.

Other than this specialized knowledge, the C program itself is very straightforward.  Occasionally the text printing will pause and wait for you to enter text at a prompt.  Do that and the program will print the text to the other terminal and continue on.

Compile-time options are communicated to Z88DK through pragmas.  This program centralizes all its pragmas in a single file "zpragma.inc".  You can read about the ones used by this program there.

# Compiling the Example

sccz80
```
zcc +zx -vn -startup=31 -clib=new -O3 terminals_x2.c -o terminals_x2 -pragma-include:zpragma.inc -create-app
```
zsdcc
```
zcc +zx -vn -startup=31 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 terminals_x2.c -o terminals_x2 -pragma-include:zpragma.inc -create-app
```
