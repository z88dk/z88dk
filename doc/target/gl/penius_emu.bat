@ECHO OFF
SET BINPATH=%CD%
SET MESSPATH=Z:\Apps\_emu\MESSUI-0.181
SET ROMPATH=Z:\Apps\_emu\_roms

REM SET EMUSYS=gl2000
REM SET EMUSYS=gl4000
SET EMUSYS=gl4004
REM SET EMUSYS=gl5000
REM SET EMUSYS=gl3000s

REM -debug	Starts a nice debugger!
"%MESSPATH%\mess.exe" -rompath "%ROMPATH%" %EMUSYS% -cart "penius.bin" -window -sleep

REM Remove MESS config directory that is created
DEL /S cfg\*.cfg
RD cfg