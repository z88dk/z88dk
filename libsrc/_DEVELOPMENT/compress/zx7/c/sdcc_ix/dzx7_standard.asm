
; void dzx7_standard(void *src, void *dst)

SECTION seg_code_zx7

PUBLIC _dzx7_standard

_dzx7_standard:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_standard.asm"
