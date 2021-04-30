
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION smc_compress

PUBLIC asm_dzx1_agile_rcs

asm_dzx1_agile_rcs:

INCLUDE "dzx1_agileRCS.asm"
ENDIF
