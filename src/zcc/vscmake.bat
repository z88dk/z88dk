@echo off
rem $Id: vscmake.bat,v 1.2 2005-03-08 18:18:36 stefano Exp $

echo ****************
echo * Building zcc *
echo ****************
cl /Fezcc -DMSDOS *.c
move zcc.exe ..\..\bin
del *.obj
