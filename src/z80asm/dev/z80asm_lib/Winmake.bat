@echo off

del /S ..\..\..\..\lib\z80asm*.lib

z80asm -xz80asm-z80-.lib -mz80 @z80asm_lib.lst
z80asm -xz80asm-z80-ixiy.lib -mz80 --IXIY @z80asm_lib.lst
z80asm -xz80asm-z80n-.lib -mz80n @z80asm_lib.lst
z80asm -xz80asm-z80n-ixiy.lib -mz80n --IXIY @z80asm_lib.lst
z80asm -xz80asm-z180-.lib -mz180 @z80asm_lib.lst
z80asm -xz80asm-z180-ixiy.lib -mz180 --IXIY @z80asm_lib.lst
z80asm -xz80asm-r2k-.lib -mr2k @z80asm_lib.lst
z80asm -xz80asm-r2k-ixiy.lib -mr2k --IXIY @z80asm_lib.lst
z80asm -xz80asm-r3k-.lib -mr3k @z80asm_lib.lst
z80asm -xz80asm-r3k-ixiy.lib -mr3k --IXIY @z80asm_lib.lst

del /S *.o
move /Y z80asm*.lib ..\..\..\..\lib
