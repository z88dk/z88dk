@echo off
setlocal

set CFLAGS=-clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size

@rem zcc +zxn -v -c %CFLAGS% fat.c

zcc +zxn -v -m -startup=31 %CFLAGS% -pragma-include:zpragma.inc @zproject.lst -o load
appmake +rom -b load -o loader.bin --rombase 0 --romsize 0x2000

dir load_*.bin

del /Q zcc_opt.def load_*.bin
