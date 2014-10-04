
; void dzx7_smart_rcs(void *src, void *dst)

SECTION seg_code_zx7

PUBLIC _dzx7_smart_rcs

_dzx7_smart_rcs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_smart_rcs.asm"
