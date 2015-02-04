@echo off
rem $Id: vscmake.bat,v 1.1 2015-02-04 16:31:54 stefano Exp $

echo ******************
echo * Building z80nm *
echo ******************
cl /Fez80nm /Igetopt *.c getopt\getopt.c
move z80nm.exe ..\..\bin
del *.obj
