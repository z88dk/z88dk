@ECHO OFF
SET Z88DK=Z:\Data\_code\_cWorkspace\z88dk.git

REM Change to git version
SET ZCCCFG=%Z88DK%\lib\config
SET PATH=%PATH%;%Z88DK%\bin

SET VGLMODEL=4000

SET PROGNAME=loader
SET VGLOPTS=-subtype=%VGLMODEL%_rom_autostart


REM Pre-Clean
DEL %PROGNAME%.bin

REM Use SDCC compiler (can not handle inline #asm/#endasm in C!)
REM SET ZCCCMD=zcc +vgl -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app
REM SET ZCCCMD=zcc +vgl -v -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app

REM Use SCCZ80 compiler
SET ZCCCMD=zcc +vgl -vn -clib=new %VGLOPTS% %SRCPATH%%PROGNAME%.c -o %PROGNAME% -create-app

ECHO Running %ZCCCMD%
%ZCCCMD%
IF ERRORLEVEL 1 GOTO:ERROR

REM Post-Clean
DEL zcc_opt.def
DEL %PROGNAME%_BSS.bin
DEL %PROGNAME%_CODE.bin
DEL %PROGNAME%_DATA.bin
DEL %PROGNAME%_interrupt_vectors.bin


:EMU
CALL loader_emu.bat %PROGNAME% gl%VGLMODEL%
GOTO:END


:ERROR
ECHO Compiler did not exit cleanly :-(

:END