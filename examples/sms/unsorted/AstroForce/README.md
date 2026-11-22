# Astro Force v1.03 by eruiz00
[Original Website](http://www.smspower.org/Homebrew/AstroForce-SMS)

The source code here consists of everything needed to compile the game and does not include raw binary assets that need conversion to sms-friendly formats using other tools as an intermediate step.  To see everything, visit the link above.

## Instructions

At the title screen, one button enters the game and the other enters the jukebox and options page.  
Do yourself a favor and choose 6 lives.

Playability is finely tuned (I think); some memorization will make things easier. There are continues. Ctrl+F1 in emulicious helps a lot! Actually I finish the game with two continues :)
* 6 stages, each with its own concepts, music, graphics and enemies + final boss stage
* 11 bosses
* 30+ enemy types
* Intro, ending
* What I like the most? The music. Mod2PSG it the perfect tool for a music snob like me.

## Compiling

zsdcc compile (optimization is high so compile time will be long ~15 mins):
~~~
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 src/bank2.c -o ./bank2.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_03 src/bank3.c -o ./bank3.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_04 src/bank4.c -o ./bank4.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_05 src/bank5.c -o ./bank5.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_06 src/bank6.c -o ./bank6.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_07 src/bank7.c -o ./bank7.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_08 src/bank8.c -o ./bank8.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_09 src/bank9.c -o ./bank9.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0A src/bank10.c -o ./bank10.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0B src/bank11.c -o ./bank11.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0C src/bank12.c -o ./bank12.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0D src/bank13.c -o ./bank13.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0E src/bank14.c -o ./bank14.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_0F src/fixedbank.c -o ./fixedbank.o
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject.lst -o astroforce -pragma-include:zpragma.inc -create-app
~~~

The compile confines all intermediate output files to the current working directory.
