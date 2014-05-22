
; void dzx7_standard_callee(void *src, void *dst)

PUBLIC dzx7_standard_callee

dzx7_standard_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "compress/zx7/z80/asm_dzx7_standard.asm"
