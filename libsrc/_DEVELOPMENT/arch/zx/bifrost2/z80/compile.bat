del bifrost2_48.bin.zx7
del bifrost2_p3.bin.zx7
pasmo --equ SPECMODEL=0 --equ STRIP_VECTOR=1 --bin BIFROST2_ENGINE.asm bifrost2_48.bin
pasmo --equ SPECMODEL=3 --equ STRIP_VECTOR=1 --bin BIFROST2_ENGINE.asm bifrost2_p3.bin
zx7 bifrost2_48.bin
zx7 bifrost2_p3.bin
pasmo --tap BIFROST2_INSTALL.asm BIFROST2
copy BIFROST2 BIFROST2.tap
pause
