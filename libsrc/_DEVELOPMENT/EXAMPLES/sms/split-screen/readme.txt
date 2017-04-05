devkitSMS example by sverx
http://www.smspower.org/forums/16281-DevkitSMSExamples

sccz80 compile:
zcc +sms -vn -startup=8 -clib=new -O3 main.c bank1.c -o split -create-app

zsdcc compile:
zcc +sms -vn -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c bank1.c -o split -create-app
