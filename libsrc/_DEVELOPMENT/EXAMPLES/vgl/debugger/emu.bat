@ECHO OFF
SET BINPATH=%CD%
SET MESSPATH=Z:\Apps\_emu\MESSUI-0.181
SET ROMPATH=Z:\Apps\_emu\_roms

REM Defaults
SET PROGNAME=debug
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

REM Can supply first param = progname
IF "%1"=="" GOTO:PROGNAME_DEF
SET PROGNAME=%1
:PROGNAME_DEF

REM Can supply second param = system
IF "%2"=="" GOTO:EMUSYS_DEF
SET EMUSYS=%2
:EMUSYS_DEF



:RUN
REM -debug	Starts a nice debugger!
REM -nothrottle
REM -skip_disclaimer -skip_gameinfo -skip_warnings
"%MESSPATH%\mess.exe" -rompath "%ROMPATH%" %EMUSYS% -cart "%PROGNAME%.bin" -window -nomax -nofilter -sleep -volume -20 -skip_gameinfo -speed 4.0

REM Remove MESS config directory that is created
DEL /S cfg\*.cfg
RD cfg