Baluba Balok by eruiz00
http://www.smspower.org/Homebrew/BalubaBalok-SMS

sccz80 compile:
// for-loops with variables declared in initializer prevent compile
// zcc +sms -v -startup=16 -clib=new -O3 game.c bank1.c -o bb -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 game.c bank1.c -o bb -create-app -pragma-include:zpragma.inc
