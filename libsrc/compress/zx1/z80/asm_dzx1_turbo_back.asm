
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION smc_compress

PUBLIC asm_dzx1_turbo_back

asm_dzx1_turbo_back:

INCLUDE "dzx1_turbo_back.asm"
ENDIF
