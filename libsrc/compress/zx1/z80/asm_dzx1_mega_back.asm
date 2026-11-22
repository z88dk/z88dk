
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION smc_compress

PUBLIC asm_dzx1_mega_back

asm_dzx1_mega_back:

INCLUDE "dzx1_mega_back.asm"
ENDIF
