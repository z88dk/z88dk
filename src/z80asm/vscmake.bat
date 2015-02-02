@echo off
rem $Id: vscmake.bat,v 1.4 2015-02-02 18:18:12 stefano Exp $

echo *******************
echo * Building z80asm *
echo *******************
cl /Fez80asm -D _CRT_SECURE_NO_DEPRECATE *.c -I.\lib lib\*.c
move z80asm.exe ..\..\bin
del *.obj
