@echo off
rem $Id: vscmake.bat,v 1.3 2006-12-11 17:46:55 stefano Exp $

echo ****************
echo * Building cpp *
echo ****************
cl /Fezcpp -D _CRT_SECURE_NO_DEPRECATE *.c
move zcpp.exe ..\..\bin
del *.obj
