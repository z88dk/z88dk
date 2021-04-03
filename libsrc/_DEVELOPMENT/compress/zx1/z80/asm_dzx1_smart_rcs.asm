
IF !__CPU_INTEL__ && !__CPU_GBZ80__
SECTION code_lib
SECTION code_compress_zx1

PUBLIC asm_dzx1_smart_rcs

asm_dzx1_smart_rcs:

INCLUDE "dzx1_smartRCS.asm"
ENDIF
