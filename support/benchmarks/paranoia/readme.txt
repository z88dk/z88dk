Before z88dk v2.5, newlib `-lm` in these recipes linked math48 (6-byte). From v2.5, `-lm` links math32. A 6-byte rerun is `--math48` with sccz80 or 80cc (zsdcc still stores 4-byte IEEE). 8-byte Microsoft format is `--mbf64` with either compiler.

PARANOIA
========

A 1980s era program that tested the reliability of a
floating point implementation.

http://www.netlib.org/paranoia/
https://archive.org/stream/byte-magazine-1985-02/1985_02_BYTE_10-02_Computing_and_the_Sciences#page/n222/mode/1up
https://en.wikipedia.org/wiki/William_Kahan

math48 (48-bit) runs under SCCZ80 only -- zsdcc links at 4-byte float precision
(SDCC double == float), so a -clib=sdcc_iy build does NOT exercise math48.

math48 via sccz80 newlib (__STDC__ must be defined; zsdcc does that already):
zcc +cpm -vn -SO3 -DNOSIGNAL -clib=new -compiler=sccz80 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o par -lm -create-app

4-byte float via zsdcc (not 48-bit; SDCC double == float):
zcc +cpm -vn -SO3 -DNOSIGNAL -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size @zproject.lst -o par -lm -create-app
