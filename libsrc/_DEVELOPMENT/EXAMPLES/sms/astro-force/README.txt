Astro Force by eruiz00
http://www.smspower.org/Homebrew/AstroForce-SMS

zsdcc compile (optimization is high so compile time will be long ~15 mins):

zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_02 bank2.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_03 bank3.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_04 bank4.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_05 bank5.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_06 bank6.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_07 bank7.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_08 bank8.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_09 bank9.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0A bank10.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0B bank11.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0C bank12.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0D bank13.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0E bank14.c
zcc +sms -v -c -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --constsegBANK_0F fixedbank.c
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject.lst -o astroforce -pragma-include:zpragma.inc -create-app
