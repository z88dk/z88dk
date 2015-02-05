@echo off
rem $Id: vscmake.bat,v 1.2 2015-02-05 12:28:02 stefano Exp $

echo ********************
echo * Building zpragma *
echo ********************
cl /Fezpragma -D _CRT_SECURE_NO_DEPRECATE *.c
move zpragma.exe ..\..\bin
del *.obj
