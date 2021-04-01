
; void dzx1_turbo_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_turbo_callee

EXTERN asm_dzx1_turbo

dzx1_turbo_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx1_turbo
