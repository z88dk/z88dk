zcc +ti82 %1.c -lm -ltigray82 -o%1.crash.82.NA.bin
bin2var %1.crash.82.NA.bin %1.crash.NA.82p
zcc +ti82ansi %1.c -lm -ltigray82 -o%1.crash.82.bin
bin2var %1.crash.82.bin %1.crash.82p
