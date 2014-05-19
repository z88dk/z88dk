copy /Y target\zx\clib_cfg.asm .
copy /Y target\zx\clib_target_cfg.asm .
z80asm -d -ns -nm -Mo -xzx_asm @target/zx/library/zx_asm.lst
move /Y zx_asm.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sccz80 @target/zx/library/zx_sccz80.lst
move /Y zx_sccz80.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sdcc_ix -D__SDCC_IX @target/zx/library/zx_sdcc_ix.lst
move /Y zx_sdcc_ix.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xzx_sdcc_iy -D__SDCC_IY -IXIY @target/zx/library/zx_sdcc_iy.lst
move /Y zx_sdcc_iy.lib lib
del /S *.o
del /S *.err

copy /Y target\cpm\clib_cfg.asm .
copy /Y target\cpm\clib_target_cfg.asm .
z80asm -d -ns -nm -Mo -xcpm_asm @target/cpm/library/cpm_asm.lst
move /Y cpm_asm.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xcpm_sccz80 @target/cpm/library/cpm_sccz80.lst
move /Y cpm_sccz80.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xcpm_sdcc_ix -D__SDCC_IX @target/cpm/library/cpm_sdcc_ix.lst
move /Y cpm_sdcc_ix.lib lib
del /S *.o
del /S *.err
z80asm -d -ns -nm -Mo -xcpm_sdcc_iy -D__SDCC_IY -IXIY @target/cpm/library/cpm_sdcc_iy.lst
move /Y cpm_sdcc_iy.lib lib
del /S *.o
del /S *.err
