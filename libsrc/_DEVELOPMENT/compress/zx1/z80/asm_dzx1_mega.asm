
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION smc_compress

PUBLIC asm_dzx1_mega

asm_dzx1_mega:

INCLUDE "dzx1_mega.asm"
ENDIF
