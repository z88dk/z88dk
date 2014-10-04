
; void dzx7_mega_callee(void *src, void *dst)

SECTION seg_code_zx7

PUBLIC dzx7_mega_callee

dzx7_mega_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "compress/zx7/z80/asm_dzx7_mega.asm"
