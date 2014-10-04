
; void dzx7_turbo(void *src, void *dst)

SECTION seg_code_zx7

PUBLIC _dzx7_turbo

_dzx7_turbo:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_turbo.asm"
