z80asm -d -ns -nm -Mo -xzx_asm @target/spectrum/library/zx_asm.lst
move /Y zx_asm.lib lib
del /S *.o
del /S *.err
