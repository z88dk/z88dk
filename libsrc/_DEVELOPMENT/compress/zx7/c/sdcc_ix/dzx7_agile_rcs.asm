
; void dzx7_agile_rcs(void *src, void *dst)

PUBLIC _dzx7_agile_rcs

_dzx7_agile_rcs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_agile_rcs.asm"
