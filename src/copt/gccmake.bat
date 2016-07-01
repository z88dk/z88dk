@echo off
rem $Id: gccmake.bat,v 1.2 2016-07-01 12:57:16 stefano Exp $

echo *****************
echo * Building copt *
echo *****************
gcc -DLOCAL_REGEXP -I. -o copt *.c regex\reg*.c
copy copt.exe ..\..\bin
del copt.exe
