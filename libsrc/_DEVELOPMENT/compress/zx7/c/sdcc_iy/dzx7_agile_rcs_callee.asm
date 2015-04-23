
; void dzx7_agile_rcs_callee(void *src, void *dst)

SECTION code_compress_zx7

PUBLIC _dzx7_agile_rcs_callee

_dzx7_agile_rcs_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_agile_rcs.asm"
