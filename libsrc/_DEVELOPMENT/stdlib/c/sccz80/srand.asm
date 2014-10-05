
; void srand(unsigned int seed)

SECTION seg_code_stdlib

PUBLIC srand

srand:

   INCLUDE "stdlib/z80/asm_srand.asm"
