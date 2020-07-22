zcc +ti85 %1.c -lm -ltigray85 -o%1.rigel.85.NA.bin
bin2var %1.rigel.85.NA.bin %1.rigel.NA.85s
zcc +ti85ansi %1.c -lm -ltigray85 -o%1.rigel.85.bin
bin2var %1.rigel.85.bin %1.rigel.85s
