zcc +ti8x %1.c -startup=1 -lm -ltigray83p -o%1.ion.8x.bin
bin2var %1.ion.8x.bin %1.ion.8xp
zcc +ti8x %1.c -startup=2 -lm -ltigray83p -o%1.mir.8x.bin
bin2var %1.mir.8x.bin %1.mir.8xp
zcc +ti8x %1.c -startup=4 -lm -ltigray83p -o%1.tse.8x.bin
bin2var %1.tse.8x.bin %1.tse.8xp
zcc +ti8x %1.c -startup=10 -lm -ltigray83p -o%1.asm.8x.bin
bin2var %1.asm.8x.bin %1.asm.8xp
