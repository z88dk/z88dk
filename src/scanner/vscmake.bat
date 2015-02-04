@echo off
rem $Id: vscmake.bat,v 1.1 2015-02-04 16:31:54 stefano Exp $

echo ********************
echo * Building zpragma *
echo ********************
cl /Fezcpp -D _CRT_SECURE_NO_DEPRECATE *.c
move zpragma.exe ..\..\bin
del *.obj
