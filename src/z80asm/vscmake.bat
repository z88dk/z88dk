@echo off
rem $Id: vscmake.bat,v 1.2 2005-03-08 18:18:36 stefano Exp $

echo *******************
echo * Building z80asm *
echo *******************
cl /Fez80asm *.c
move z80asm.exe ..\..\bin
del *.obj
