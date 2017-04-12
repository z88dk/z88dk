DataStorm by haroldoop
http://www.smspower.org/Homebrew/DataStorm-SMS

sccz80 compile:
// unable to compile due to multi-dimensional array
zcc +sms -v -startup=8 -clib=new -O3 datastorm.c gfx.c psg.c -o datastorm -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 datastorm.c gfx.c -o datastorm --fsigned-char -create-app -pragma-include:zpragma.inc
