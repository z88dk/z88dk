Moggy Master by mojontwins
http://www.smspower.org/Homebrew/MoggyMaster-SMS

sccz80 compile:
// broken compile - check c interface to smslib
zcc +sms -v -c -clib=new --constseg=BANK_02 bank2.c
zcc +sms -v -c -clib=new --constseg=BANK_03 bank3.c
zcc +sms -v -startup=8 -clib=new -O3 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_03 bank3.c
zcc +sms -v -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc


NOTE:
Normal source code organization does not place code in header files.  This defeats C's type
checking and makes it impossible to break large compiles into incremental compiles.
