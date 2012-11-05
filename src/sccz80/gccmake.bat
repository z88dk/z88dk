@echo off
rem $Id: gccmake.bat,v 1.1 2012-11-05 08:15:51 stefano Exp $

echo *******************
echo * Building sccz80 *
echo *******************
gcc -o sccz80 *.c
copy sccz80.exe ..\..\bin
del sccz80.exe
