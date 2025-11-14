## Compile

```
zcc +zxn -v -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c graphics.asm.m4 interrupt.asm -o main -pragma-include:zpragma.inc -subtype=nex -Cz"--clean" -create-app
```

## Run

These keys are active once the sna is launched:

```
s   fewer software sprites
S   more software sprites

c   toggle clash on software sprites

h   fewer hardware sprites
H   more hardware sprites

p   toggle ula and sprite layer priorities

z   fewer splats
Z   more splats
```

## Description

Up to 64 software sprites using the sp1 engine and up to 64 hardware sprites are pushed around with the
cpu running at 14MHz.  The layer priority is set so that layer 2 is on bottom, then the relative order of 
the ula layer (where sp1 draws) and the sprite layer can be toggled.  Layer 2 is scrolled in the interrupt
routine.

Splats are sp1 background tiles placed in the foreground so that sp1's software sprites move behind them.

The colour clash toggle changes sp1's sprites from ink only to ink and complementary paper.  While ink only
there is no colour clash interaction with either layer 2 or the hardware sprites.

## Note

This is another partial demonstration.  In the future there will be api functions to simplify use of the
hardware sprites and layer 2.
