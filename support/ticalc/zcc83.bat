rem @echo off
zcc %1.c
del a.bin
copy a.bas %1.bin
echo g>devp83
echo q>>devp83
debug devpac83.com %1 < devp83
del %1.bin
