@echo off
rem $Id: gccmake.bat,v 1.1 2012-11-05 08:15:51 stefano Exp $

echo *****************
echo * Building copt *
echo *****************
gcc -o copt *.c
@rem gcc -ocopt -Iregex -DUSE_REGEXP -DLOCAL_REGEXP *.c regex\reg*.c
copy copt.exe ..\..\bin
del copt.exe
