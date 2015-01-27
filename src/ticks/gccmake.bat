@echo off
rem $Id: gccmake.bat,v 1.1 2015-01-27 05:40:15 aralbrec Exp $

echo ******************
echo * Building ticks *
echo ******************
gcc -o ticks *.c
@rem gcc -oticks *.c
copy ticks.exe ..\..\bin
del ticks.exe
