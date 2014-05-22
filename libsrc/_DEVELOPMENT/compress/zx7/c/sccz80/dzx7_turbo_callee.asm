
; void dzx7_turbo_callee(void *src, void *dst)

PUBLIC dzx7_turbo_callee

dzx7_turbo_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "compress/zx7/z80/asm_dzx7_turbo.asm"
