@echo off
rem $Id: gccmake.bat,v 1.58 2015-09-13 19:21:23 pauloscustodio Exp $

echo *******************
echo * Building z80asm *
echo *******************
gcc -oz80asm.exe -I.\lib -Wall *.c lib\*.c
move z80asm.exe ..\..\bin
del *.o
