@echo off

echo ******************
echo * Building z80nm *
echo ******************
gcc -o z80nm -I getopt *.c getopt/getopt.c
copy z80nm.exe ..\..\bin
del z80nm.exe
