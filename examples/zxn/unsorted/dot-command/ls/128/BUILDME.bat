@echo off

zx7 -f ls-help.txt
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o ls -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean" -create-app
del /S ls_UNASSIGNED.bin zcc_opt.def ls-help.txt.zx7
