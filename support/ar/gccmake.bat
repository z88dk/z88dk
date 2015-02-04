@echo off
rem $Id: gccmake.bat,v 1.1 2015-02-04 16:31:54 stefano Exp $

echo ******************
echo * Building z80nm *
echo ******************
gcc -o z80nm -I getopt *.c getopt/getopt.c
copy z80nm.exe ..\..\bin
del z80nm.exe
