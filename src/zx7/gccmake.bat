@echo off
rem $Id: gccmake.bat,v 1.3 2015-09-02 03:57:18 aralbrec Exp $

echo ****************
echo * Building zx7 *
echo ****************
gcc -o zx7 zx7.c compress.c optimize.c
gcc -o dzx7 dzx7.c
@rem gcc -ozx7 *.c
copy *.exe ..\..\bin
del *.exe
