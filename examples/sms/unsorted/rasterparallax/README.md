# Raster Parallax by sverx
[Original Source](http://www.smspower.org/Homebrew/RasterParallax-SMS)

## Compile

sccz80 compile (generated code not fast enough in VBI):
~~~
zcc +sms -v -c -clib=new --constsegBANK_02 bank2.c
zcc +sms -v -startup=16 -clib=new -O2 main.c bank2.o -o rp -create-app
~~~
zsdcc compile (high optimization may lead to long compile time):
~~~
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 bank2.c
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c bank2.o -o rp -create-app
~~~
