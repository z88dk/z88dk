
SECTION code_clib
SECTION code_l_sccz80

IF !__CPU_INTEL__ && !__CPU_GBZ80__


PUBLIC l_jpiy

l_jpiy:

   jp (iy)

ENDIF
