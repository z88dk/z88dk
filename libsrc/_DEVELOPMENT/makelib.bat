z80asm -d -ns -nm -Mo -xzx_asm @target/spectrum/library/zx_asm.lst
move /Y zx_asm.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sccz80 @target/spectrum/library/zx_lr_sccz80.lst
move /Y zx_sccz80.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sdcc_ix -D__SDCC_IX @target/spectrum/library/zx_sdcc_ix.lst
move /Y zx_sdcc_ix.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sdcc_iy -D__SDCC_IY -IXIY @target/spectrum/library/zx_sdcc_iy.lst
move /Y zx_sdcc_iy.lib lib
del /S *.o
del /S *.err
