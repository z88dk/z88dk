@echo off
rem $Id: gccmake.bat,v 1.1 2015-02-04 16:31:54 stefano Exp $

echo ********************
echo * Building zpragma *
echo ********************
gcc -o zpragma *.c
copy zpragma.exe ..\..\bin
del zpragma.exe
