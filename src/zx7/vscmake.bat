@echo off
rem $Id: vscmake.bat,v 1.4 2015-09-02 03:57:18 aralbrec Exp $

echo ****************
echo * Building zx7 *
echo ****************
cl /Fezx7 zx7.c compress.c optimize.c
cl /Fedzx7 dzx7.c
move *.exe ..\..\bin
del *.obj
