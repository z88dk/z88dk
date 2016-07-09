@echo off

echo ******************
echo * Building z80nm *
echo ******************
cl /Fez80nm /Igetopt *.c getopt\getopt.c
move z80nm.exe ..\..\bin
del *.obj
