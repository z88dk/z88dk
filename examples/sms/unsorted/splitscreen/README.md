# Split Screen by sverx
[Original Source](http://www.smspower.org/forums/16281-DevkitSMSExamples)

## Compiling

sccz80 compile:
~~~
zcc +sms -vn -startup=16 -clib=new -O3 main.c bank1.c -o split -create-app
~~~
zsdcc compile (high optimization level can lead to long compile time):
~~~
zcc +sms -vn -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c bank1.c -o split -create-app
~~~
