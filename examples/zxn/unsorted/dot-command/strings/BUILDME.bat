@echo off

zx7 -f help.txt
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o strings -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app
del /S help.txt.zx7 strings_UNASSIGNED.bin zcc_opt.def
