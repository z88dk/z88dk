@echo off
rem $Id: gccmake.bat,v 1.1 2012-11-05 08:15:51 stefano Exp $

echo ********************
echo * Building appmake *
echo ********************
gcc -o appmake -DWIN32 *.c
copy appmake.exe ..\..\bin
del appmake.exe
