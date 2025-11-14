PARANOIA
========

A 1980s era program that tested the reliability of a
floating point implementation.

http://www.netlib.org/paranoia/
https://archive.org/stream/byte-magazine-1985-02/1985_02_BYTE_10-02_Computing_and_the_Sciences#page/n222/mode/1up
https://en.wikipedia.org/wiki/William_Kahan

zsdcc / math 48 (__STDC__ must also be defined but zsdcc does that already)
zcc +cpm -vn -SO3 -DNOSIGNAL -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size @zproject.lst -o par -lm -create-app
