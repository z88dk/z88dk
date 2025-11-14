# Baluba Balok by eruiz00  
Jan 29, 2017  
[Original Website](http://www.smspower.org/Homebrew/BalubaBalok-SMS)

The source code here consists of everything needed to compile the game and does not include raw binary assets that need conversion to sms-friendly formats using other tools as an intermediate step.  To see everything, visit the link above.

## Instructions

None!  Try bumping things from underneath.  Collecting will cause explosions to kill the baddies.

## Compiling

zsdcc compile (optimization is high so compile time can be long):
~~~
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 src/game.c src/bank1.c -o bb -create-app -pragma-include:zpragma.inc
~~~
