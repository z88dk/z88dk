@ECHO OFF
SET Z88DK=Z:\Data\_code\_cWorkspace\V-Tech\_software\z88dk.git

REM Change to git version
SET ZCCCFG=%Z88DK%\lib\config
SET PATH=%PATH%;%Z88DK%\bin

SET PROGNAME=hello
REM SET PROGNAME=hello_nostdio

REM SET SRCPATH=..\
REM SET PROGNAME=eliza
REM SET PROGNAME=heapsort
REM SET PROGNAME=beepfx



REM Clean
DEL %PROGNAME%.bin

REM Use SDCC compiler (can not handle inline #asm/#endasm in C!)
REM zcc +vgl -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app
REM zcc +vgl -v -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app

REM Use SCCZ80 compiler
zcc +vgl -vn -clib=new %SRCPATH%%PROGNAME%.c -o %PROGNAME% -create-app
IF ERRORLEVEL 1 GOTO:ERROR
GOTO:NOERROR

:ERROR
ECHO Compiler did not exit cleanly :-(
GOTO:END

:NOERROR
REM Clean
DEL %PROGNAME%_BSS.bin
DEL %PROGNAME%_CODE.bin
DEL %PROGNAME%_DATA.bin
DEL %PROGNAME%_interrupt_vectors.bin
CALL emu.bat %PROGNAME%
GOTO:END

:END