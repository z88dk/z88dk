Raster Parallax by sverx
http://www.smspower.org/Homebrew/RasterParallax-SMS

sccz80 compile:
// generated code seems too slow to complete in time for raster effect
// zcc +sms -v -c -clib=new --constsegBANK_02 bank2.c
// zcc +sms -v -startup=16 -clib=new -O3 main.c bank2.o -o rp -create-app

zsdcc compile:
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c bank2.o -o rp -create-app
