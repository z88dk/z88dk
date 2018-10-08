@echo off

zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o run -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app
del /S run_UNASSIGNED.bin zcc_opt.def
