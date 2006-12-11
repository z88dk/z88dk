@echo off
rem $Id: vscmake.bat,v 1.3 2006-12-11 17:46:55 stefano Exp $

echo *******************
echo * Building sccz80 *
echo *******************
cl /Fesccz80 -D _CRT_SECURE_NO_DEPRECATE *.c
move sccz80.exe ..\..\bin
del *.obj
