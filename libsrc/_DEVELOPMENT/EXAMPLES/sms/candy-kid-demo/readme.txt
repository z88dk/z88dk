Candy Kid Demo by eruiz00
http://github.com/SteveProXNA/CandyKidDemoSMS
http://www.smspower.org/Homebrew/CandyKidDemo-SMS

sccz80 compile:
// unable to compile due to multi-dimensional array
zcc +sms -v -startup=8 -clib=new -O3 main.c gfx.c psg.c -o ckd -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c gfx.c psg.c -o ckd -create-app -pragma-include:zpragma.inc


NOTE:
Normal source code organization does not place code in header files.  This defeats C's type
checking and makes it impossible to break large compiles into incremental compiles.
