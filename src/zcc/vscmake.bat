@echo off
rem $Id: vscmake.bat,v 1.3 2006-12-11 17:46:55 stefano Exp $

echo ****************
echo * Building zcc *
echo ****************
cl /Fezcc -DMSDOS -D _CRT_SECURE_NO_DEPRECATE *.c
move zcc.exe ..\..\bin
del *.obj
