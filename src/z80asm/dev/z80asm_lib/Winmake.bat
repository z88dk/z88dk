@echo off

del /S ..\..\..\..\lib\z80asm*.lib

z80asm -xz80asm-z80-.lib --cpu=z80 @z80asm_lib.lst
z80asm -xz80asm-z80-ixiy.lib --cpu=z80 --IXIY @z80asm_lib.lst
z80asm -xz80asm-z80_zxn-.lib --cpu=z80-zxn @z80asm_lib.lst
z80asm -xz80asm-z80_zxn-ixiy.lib --cpu=z80-zxn --IXIY @z80asm_lib.lst
z80asm -xz80asm-z180-.lib --cpu=z180 @z80asm_lib.lst
z80asm -xz80asm-z180-ixiy.lib --cpu=z180 --IXIY @z80asm_lib.lst
z80asm -xz80asm-r2k-.lib --cpu=r2k @z80asm_lib.lst
z80asm -xz80asm-r2k-ixiy.lib --cpu=r2k --IXIY @z80asm_lib.lst
z80asm -xz80asm-r3k-.lib --cpu=r3k @z80asm_lib.lst
z80asm -xz80asm-r3k-ixiy.lib --cpu=r3k --IXIY @z80asm_lib.lst

del /S *.o
move /Y z80asm*.lib ..\..\..\..\lib
