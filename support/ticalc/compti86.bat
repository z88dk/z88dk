zcc +ti86 %1.c -startup=1 -lm -ltigray86 -o%1
prgm86 %1
del %1.LASM.86.NA.obj
ren %1 %1.LASM.86.NA.obj
del %1.LASM.86.NA.86p
ren %1.86p %1.LASM.86.NA.86p
zcc +ti86 %1.c -startup=2 -lm -ltigray86 -o%1
prgm86 %1
del %1.ASE.86.NA.obj
ren %1 %1.ASE.86.NA.obj
del %1.ASE.86.NA.86p
ren %1.86p %1.ASE.86.NA.86p
zcc +ti86 %1.c -startup=3 -lm -ltigray86 -o%1
prgm86 %1
del %1.zap2000.86.NA.obj
ren %1 %1.zap2000.86.NA.obj
del %1.zap2000.86.NA.86p
ren %1.86p %1.zap2000.86.NA.86p
zcc +ti86 %1.c -startup=4 -lm -ltigray86 -o%1
prgm86 %1
del %1.emanon.86.NA.obj
ren %1 %1.emanon.86.NA.obj
del %1.emanon.86.NA.86p
ren %1.86p %1.emanon.86.NA.86p
zcc +ti86 %1.c -startup=5 -lm -ltigray86 -o%1
prgm86 %1
del %1.emb_LargeLD.86.NA.obj
ren %1 %1.emb_LargeLD.86.NA.obj
del %1.emb_LargeLD.86.NA.86p
ren %1.86p %1.emb_LargeLD.86.NA.86p
zcc +ti86 %1.c -startup=10 -lm -ltigray86 -o%1
prgm86 %1
del %1.asm.86.NA.obj
ren %1 %1.asm.86.NA.obj
del %1.asm.86.NA.86p
ren %1.86p %1.asm.86.NA.86p
zcc +ti86ansi %1.c -startup=1 -lm -ltigray86 -o%1
prgm86 %1
del %1.LASM.86.obj
del %1.LASM.86p
ren %1 %1.LASM.86.obj
ren %1.86p %1.LASM.86p
zcc +ti86ansi %1.c -startup=2 -lm -ltigray86 -o%1
prgm86 %1
del %1.ASE.86.obj
del %1.ASE.86p
ren %1 %1.ASE.86.obj
ren %1.86p %1.ASE.86p
zcc +ti86ansi %1.c -startup=3 -lm -ltigray86 -o%1
prgm86 %1
del %1.zap2000.86.obj
del %1.zap2000.86p
ren %1 %1.zap2000.86.obj
ren %1.86p %1.zap2000.86p
zcc +ti86ansi %1.c -startup=4 -lm -ltigray86 -o%1
prgm86 %1
del %1.emanon.86.obj
del %1.emanon.86p
ren %1 %1.emanon.86.obj
ren %1.86p %1.emanon.86p
zcc +ti86ansi %1.c -startup=5 -lm -ltigray86 -o%1
prgm86 %1
del %1.emb_LargeLD.86.obj
del %1.emb_LargeLD.86p
ren %1 %1.emb_LargeLD.86.obj
ren %1.86p %1.emb_LargeLD.86p
zcc +ti86ansi %1.c -startup=10 -lm -ltigray86 -o%1
prgm86 %1
del %1.asm.86.obj
del %1.asm.86p
ren %1 %1.asm.86.obj
ren %1.86p %1.asm.86p
