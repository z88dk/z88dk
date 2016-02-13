
; void dzx7_standard_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_standard_back_callee

EXTERN asm_dzx7_standard_back

dzx7_standard_back_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_dzx7_standard_back
