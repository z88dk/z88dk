@echo off
rem $Id: vscmake.bat,v 1.3 2015-02-04 16:31:54 stefano Exp $

echo ****************
echo * Building zx7 *
echo ****************
cl /Fezx7 *.c
move zx7.exe ..\..\bin
del *.obj
