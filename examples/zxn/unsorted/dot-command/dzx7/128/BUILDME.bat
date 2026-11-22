@echo off

zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o dzx7 -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean --exclude-sections IGNORE" -create-app
del /S dzx7_UNASSIGNED.bin dzx7_IGNORE.bin zcc_opt.def
