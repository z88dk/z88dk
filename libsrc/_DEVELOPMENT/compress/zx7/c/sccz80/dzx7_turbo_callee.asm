
; void dzx7_turbo_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_turbo_callee

EXTERN asm_dzx7_turbo

dzx7_turbo_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx7_turbo
