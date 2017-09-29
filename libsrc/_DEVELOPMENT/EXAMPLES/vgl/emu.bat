@ECHO OFF
SET BINPATH=%CD%
SET MESSPATH=Z:\Apps\_emu\MESSUI-0.181
SET ROMPATH=Z:\Apps\_emu\_roms

IF "%1"=="" GOTO:DEF
REM SET PROGNAME=hello
SET PROGNAME=%1
GOTO:RUN
:DEF
SET PROGNAME=hello

:RUN
REM SET EMUSYS=gl2000
REM SET EMUSYS=gl2000c
REM SET EMUSYS=gl2000p
REM SET EMUSYS=gl3000s
SET EMUSYS=gl4000
REM SET EMUSYS=gl4004
REM SET EMUSYS=gl5000
REM SET EMUSYS=gl5005x
REM SET EMUSYS=gl6000sl
REM SET EMUSYS=gl6600cx
REM SET EMUSYS=gl7007sl
REM SET EMUSYS=gl8008cx

REM -debug	Starts a nice debugger!
"%MESSPATH%\mess.exe" -rompath "%ROMPATH%" %EMUSYS% -cart "%PROGNAME%.bin" -window -nomax -nofilter -sleep

REM Remove MESS config directory that is created
DEL /S cfg\*.cfg
RD cfg