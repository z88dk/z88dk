z80asm -d -ns -nm -Mo -xzx_sccz80 @target/spectrum/zx_sccz80.lst
move /Y zx_sccz80.lib lib
del /S *.o
del /S *.err
