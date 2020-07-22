zcc +ti83 %1.c -startup=1 -lm -ltigray83 -o%1.ion.83.NA.bin
bin2var %1.ion.83.NA.bin %1.ion.NA.83p
zcc +ti83 %1.c -startup=2 -lm -ltigray83 -o%1.ven.83.NA.bin
bin2var %1.ven.83.NA.bin %1.ven.NA.83p
zcc +ti83 %1.c -startup=3 -lm -ltigray83 -o%1.zes.83.NA.bin
bin2var %1.zes.83.NA.bin %1.zes.NA.83p
zcc +ti83 %1.c -startup=4 -lm -ltigray83 -o%1.anova.83.NA.bin
bin2var %1.anova.83.NA.bin %1.anova.NA.83p
zcc +ti83 %1.c -startup=5 -lm -ltigray83 -o%1.tiexplorer.83.NA.bin
bin2var %1.tiexplorer.83.NA.bin %1.tiexplorer.NA.83p
zcc +ti83 %1.c -startup=6 -lm -ltigray83 -o%1.ashell.83.NA.bin
bin2var %1.ashell.83.NA.bin %1.ashell.NA.83p
zcc +ti83 %1.c -startup=7 -lm -ltigray83 -o%1.sos.83.NA.bin
bin2var %1.sos.83.NA.bin %1.sos.NA.83p
zcc +ti83 %1.c -startup=8 -lm -ltigray83 -o%1.ve.83.NA.bin
bin2var %1.ve.83.NA.bin %1.ve.NA.83p
zcc +ti83 %1.c -startup=9 -lm -ltigray83 -o%1.zasm.83.NA.bin
bin2var %1.zasm.83.NA.bin %1.zasm.NA.83p
zcc +ti83 %1.c -startup=10 -lm -ltigray83 -o%1.asm.83.NA.bin
bin2var %1.asm.83.NA.bin %1.asm1.NA.83p
bin2var2 %1.asm.83.NA.bin %1.asm2.NA.83p

zcc +ti83ansi %1.c -startup=1 -lm -ltigray83 -o%1.ion.83.bin
bin2var %1.ion.83.bin %1.ion.83p
zcc +ti83ansi %1.c -startup=2 -lm -ltigray83 -o%1.ven.83.bin
bin2var %1.ven.83.bin %1.ven.83p
zcc +ti83ansi %1.c -startup=3 -lm -ltigray83 -o%1.zes.83.bin
bin2var %1.zes.83.bin %1.zes.83p
zcc +ti83ansi %1.c -startup=4 -lm -ltigray83 -o%1.anova.83.bin
bin2var %1.anova.83.bin %1.anova.83p
zcc +ti83ansi %1.c -startup=5 -lm -ltigray83 -o%1.tiexplorer.83.bin
bin2var %1.tiexplorer.83.bin %1.tiexplorer.83p
zcc +ti83ansi %1.c -startup=6 -lm -ltigray83 -o%1.ashell.83.bin
bin2var %1.ashell.83.bin %1.ashell.83p
zcc +ti83ansi %1.c -startup=7 -lm -ltigray83 -o%1.sos.83.bin
bin2var %1.sos.83.bin %1.sos.83p
zcc +ti83ansi %1.c -startup=8 -lm -ltigray83 -o%1.ve.83.bin
bin2var %1.ve.83.bin %1.ve.83p
zcc +ti83ansi %1.c -startup=9 -lm -ltigray83 -o%1.zasm.83.bin
bin2var %1.zasm.83.bin %1.zasm.83p
zcc +ti83ansi %1.c -startup=10 -lm -ltigray83 -o%1.asm.83.bin
bin2var %1.asm.83.bin %1.asm1.83p
bin2var2 %1.asm.83.bin %1.asm2.83p
