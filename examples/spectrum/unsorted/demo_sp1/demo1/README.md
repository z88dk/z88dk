# ZX SPECTRUM SP1 DEMO 1
By szeliga @ worldofspectrum.org forums

## Compile the Demo

1. SCCZ80 + New C Library
```
zcc +zx -vn -clib=new -startup=31 @sp1demo.lst -o demo -create-app
```
2. ZSDCC + New C library
```
zcc +zx -vn -SO3 -clib=sdcc_iy -startup=31 --max-allocs-per-node200000 @sp1demo.lst -o demo -create-app
```

## Controls

Press a key at any time to reset the demo.
