@echo off
tasm -80 -i -b %1.z80 %1.bin
bin2var2 %1.bin %1.8xp
del %1.bin >nul
