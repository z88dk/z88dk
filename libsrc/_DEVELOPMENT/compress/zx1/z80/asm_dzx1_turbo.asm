
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION smc_compress

PUBLIC asm_dzx1_turbo

asm_dzx1_turbo:

INCLUDE "dzx1_turbo.asm"
ENDIF
