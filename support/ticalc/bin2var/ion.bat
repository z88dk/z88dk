@echo off
echo ----- Assembling %1 for the TI-83 Plus...
echo #define TI83P >temp.z80
if exist %1.z80 type %1.z80 >>temp.z80
if exist %1.asm type %1.asm >>temp.z80
tasm -80 -i -b temp.z80 %1.bin
if errorlevel 1 goto ERRORS
bin2var %1.bin %1.8xp
echo ----- Assembling %1 for the TI-83...
echo #define TI83 >temp.z80
if exist %1.z80 type %1.z80 >>temp.z80
if exist %1.asm type %1.asm >>temp.z80
tasm -80 -i -b temp.z80 %1.bin
if errorlevel 1 goto ERRORS
bin2var %1.bin %1.83p
echo ----- Success!
echo TI-83 version is %1.83p
echo TI-83 Plus version is %1.8xp
goto DONE
:ERRORS
echo ----- There were errors.
:DONE
del temp.z80 >nul
del %1.bin >nul
