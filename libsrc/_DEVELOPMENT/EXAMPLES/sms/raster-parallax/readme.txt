Raster Parallax by sverx
http://www.smspower.org/Homebrew/RasterParallax-SMS

sccz80 compile:
// sccz80 currently lacks a section assignment option
// the simple solution is to assign data as binaries to sections in an asm file
// but sms programmers are using tools to generate c arrays instead of asm files
zcc +sms -vn -startup=8 -clib=new -O3 main.c bank2.o -o rp -create-app

zsdcc compile:
zcc +sms -vn -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -vn -startup=8 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c bank2.o -o rp -create-app
