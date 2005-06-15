@echo off
set TOP=C:\GCJ
set MINGDIR=%TOP%
set PATH=%PATH%;%MINGDIR%\bin;%MINGDIR%\mingw32\bin;%MINGDIR%\libexec\gcc\mingw32\3.4.2
gcc -O3 -march=i486 -o deploy_z88dk.exe deploy.c
strip deploy_z88dk.exe
echo Done.
pause
