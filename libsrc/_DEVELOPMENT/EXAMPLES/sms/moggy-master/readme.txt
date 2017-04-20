Moggy Master by mojontwins
http://www.smspower.org/Homebrew/MoggyMaster-SMS

sccz80 compile:
// broken compile - check c interface to smslib
// zcc +sms -v -c -clib=new --constsegBANK_02 bank2.c
// zcc +sms -v -c -clib=new --constsegBANK_03 bank3.c
// zcc +sms -v -startup=16 -clib=new -O3 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_03 bank3.c
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc
