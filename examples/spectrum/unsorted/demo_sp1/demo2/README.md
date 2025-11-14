# ZX SPECTRUM SP1 DEMO 2
(C) 2012 Timmy

A simple demo program to show how z88dk and sp1 can be used to make a game.

http://www.worldofspectrum.org/forums/discussion/37467/a-z88dk-sp1-demo-with-source
http://www.worldofspectrum.org/forums/discussion/comment/864043/#Comment_864043

## Compile the Demo

1. SCCZ80 + New C Library
```
zcc +zx -vn -O3 -startup=31 -clib=new demo.c graphics.asm -o demo -create-app
```
2. ZSDCC + New C library
```
zcc +zx -vn -SO3 -startup=31 -clib=sdcc_iy --max-allocs-per-node200000 demo.c graphics.asm -o demo -create-app
```

## Controls

 q = increase number of sprites  
 a = decrease number of sprites  
 o = exit to basic  
 p = change background  
 space = toggle border timer
 