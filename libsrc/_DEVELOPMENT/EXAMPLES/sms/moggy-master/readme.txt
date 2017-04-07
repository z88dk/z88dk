Moggy Master by mojontwins
http://www.smspower.org/Homebrew/MoggyMaster-SMS

sccz80 compile:
// sccz80 currently lacks a section assignment option
// the simple solution is to assign data as binaries to sections in an asm file
// but sms programmers are using tools to generate c arrays instead of asm files
zcc +sms -vn -startup=8 -clib=new -O3 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -vn -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -vn -c -clib=sdcc_iy --constsegBANK_03 bank3.c
zcc +sms -vn -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 wtf.c bank2.o bank3.o -o wtf -create-app -pragma-include:zpragma.inc


NOTE:
This is not normal source code organization.  Code is not normally placed in headers.
